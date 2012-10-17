From: akpm@linux-foundation.org
Subject: + revert-epoll-support-for-disabling-items-and-a-self-test-app.patch added to -mm tree
Date: Wed, 17 Oct 2012 16:30:18 -0700
Message-ID: <20121017233019.CA9DA5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:64750 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab2JQXaX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 19:30:23 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so493035lbo.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 16:30:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mtk.manpages@gmail.com, palewis@adobe.com


The patch titled
     Subject: revert "epoll: support for disabling items, and a self-test app"
has been added to the -mm tree.  Its filename is
     revert-epoll-support-for-disabling-items-and-a-self-test-app.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "epoll: support for disabling items, and a self-test app"

Revert

commit 03a7beb55b9fad363f0dd33e72ccf2d3e1c2a406
Author: Paton J. Lewis <palewis@adobe.com>
Date:   Thu Oct 4 17:13:39 2012 -0700

    epoll: support for disabling items, and a self-test app

Pending resolution of the issues identifier by Michael Kerrisk:

: I've taken a look at this patch as it currently stands in 3.7-rc1, and
: done a bit of testing. (By the way, the test program
: tools/testing/selftests/epoll/test_epoll.c does not compile...)
: 
: There are one or two places where the behavior seems a little strange,
: so I have a question or two at the end of this mail. But other than
: that, I want to check my understanding so that the interface can be
: correctly documented.
: 
: Just to go though my understanding, the problem is the following
: scenario in a multithreaded application:
: 
: 1. Multiple threads are performing epoll_wait() operations,
:    and maintaining a user-space cache that contains information
:    corresponding to each file descriptor being monitored by
:    epoll_wait().
: 
: 2. At some point, a thread wants to delete (EPOLL_CTL_DEL)
:    a file descriptor from the epoll interest list, and
:    delete the corresponding record from the user-space cache.
: 
: 3. The problem with (2) is that some other thread may have
:    previously done an epoll_wait() that retrieved information
:    about the fd in question, and may be in the middle of using
:    information in the cache that relates to that fd. Thus,
:    there is a potential race.
: 
: 4. The race can't solved purely in user space, because doing
:    so would require applying a mutex across the epoll_wait()
:    call, which would of course blow thread concurrency.
: 
: Right?
: 
: Your solution is the EPOLL_CTL_DISABLE operation. I want to
: confirm my understanding about how to use this flag, since
: the description that has accompanied the patches so far
: has been a bit sparse
: 
: 0. In the scenario you're concerned about, deleting a file
:    descriptor means (safely) doing the following:
:    (a) Deleting the file descriptor from the epoll interest list
:        using EPOLL_CTL_DEL
:    (b) Deleting the corresponding record in the user-space cache
: 
: 1. It's only meaningful to use this EPOLL_CTL_DISABLE in
:    conjunction with EPOLLONESHOT.
: 
: 2. Using EPOLL_CTL_DISABLE without using EPOLLONESHOT in
:    conjunction is a logical error.
: 
: 3. The correct way to code multithreaded applications using
:    EPOLL_CTL_DISABLE and EPOLLONESHOT is as follows:
: 
:    a. All EPOLL_CTL_ADD and EPOLL_CTL_MOD operations should
:       should EPOLLONESHOT.
: 
:    b. When a thread wants to delete a file descriptor, it
:       should do the following:
: 
:       [1] Call epoll_ctl(EPOLL_CTL_DISABLE)
:       [2] If the return status from epoll_ctl(EPOLL_CTL_DISABLE)
:           was zero, then the file descriptor can be safely
:           deleted by the thread that made this call.
:       [3] If the epoll_ctl(EPOLL_CTL_DISABLE) fails with EBUSY,
:           then the descriptor is in use. In this case, the calling
:           thread should set a flag in the user-space cache to
:           indicate that the thread that is using the descriptor
:           should perform the deletion operation.
: 
: Is all of the above correct?
: 
: The implementation depends on checking on whether
: (events & ~EP_PRIVATE_BITS) == 0
: This replies on the fact that EPOLL_CTL_AD and EPOLL_CTL_MOD always
: set EPOLLHUP and EPOLLERR in the 'events' mask, and EPOLLONESHOT
: causes those flags (as well as all others in ~EP_PRIVATE_BITS) to be
: cleared.
: 
: A corollary to the previous paragraph is that using EPOLL_CTL_DISABLE
: is only useful in conjunction with EPOLLONESHOT. However, as things
: stand, one can use EPOLL_CTL_DISABLE on a file descriptor that does
: not have EPOLLONESHOT set in 'events' This results in the following
: (slightly surprising) behavior:
: 
: (a) The first call to epoll_ctl(EPOLL_CTL_DISABLE) returns 0
:     (the indicator that the file descriptor can be safely deleted).
: (b) The next call to epoll_ctl(EPOLL_CTL_DISABLE) fails with EBUSY.
: 
: This doesn't seem particularly useful, and in fact is probably an
: indication that the user made a logic error: they should only be using
: epoll_ctl(EPOLL_CTL_DISABLE) on a file descriptor for which
: EPOLLONESHOT was set in 'events'. If that is correct, then would it
: not make sense to return an error to user space for this case?

Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: "Paton J. Lewis" <palewis@adobe.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c                             |   38 --
 include/uapi/linux/eventpoll.h             |    1 
 tools/testing/selftests/Makefile           |    2 
 tools/testing/selftests/epoll/Makefile     |   11 
 tools/testing/selftests/epoll/test_epoll.c |  344 -------------------
 5 files changed, 4 insertions(+), 392 deletions(-)

diff -puN fs/eventpoll.c~revert-epoll-support-for-disabling-items-and-a-self-test-app fs/eventpoll.c
--- a/fs/eventpoll.c~revert-epoll-support-for-disabling-items-and-a-self-test-app
+++ a/fs/eventpoll.c
@@ -346,7 +346,7 @@ static inline struct epitem *ep_item_fro
 /* Tells if the epoll_ctl(2) operation needs an event copy from userspace */
 static inline int ep_op_has_event(int op)
 {
-	return op == EPOLL_CTL_ADD || op == EPOLL_CTL_MOD;
+	return op != EPOLL_CTL_DEL;
 }
 
 /* Initialize the poll safe wake up structure */
@@ -676,34 +676,6 @@ static int ep_remove(struct eventpoll *e
 	return 0;
 }
 
-/*
- * Disables a "struct epitem" in the eventpoll set. Returns -EBUSY if the item
- * had no event flags set, indicating that another thread may be currently
- * handling that item's events (in the case that EPOLLONESHOT was being
- * used). Otherwise a zero result indicates that the item has been disabled
- * from receiving events. A disabled item may be re-enabled via
- * EPOLL_CTL_MOD. Must be called with "mtx" held.
- */
-static int ep_disable(struct eventpoll *ep, struct epitem *epi)
-{
-	int result = 0;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ep->lock, flags);
-	if (epi->event.events & ~EP_PRIVATE_BITS) {
-		if (ep_is_linked(&epi->rdllink))
-			list_del_init(&epi->rdllink);
-		/* Ensure ep_poll_callback will not add epi back onto ready
-		   list: */
-		epi->event.events &= EP_PRIVATE_BITS;
-		}
-	else
-		result = -EBUSY;
-	spin_unlock_irqrestore(&ep->lock, flags);
-
-	return result;
-}
-
 static void ep_free(struct eventpoll *ep)
 {
 	struct rb_node *rbp;
@@ -1048,6 +1020,8 @@ static void ep_rbtree_insert(struct even
 	rb_insert_color(&epi->rbn, &ep->rbr);
 }
 
+
+
 #define PATH_ARR_SIZE 5
 /*
  * These are the number paths of length 1 to 5, that we are allowing to emanate
@@ -1813,12 +1787,6 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 		} else
 			error = -ENOENT;
 		break;
-	case EPOLL_CTL_DISABLE:
-		if (epi)
-			error = ep_disable(ep, epi);
-		else
-			error = -ENOENT;
-		break;
 	}
 	mutex_unlock(&ep->mtx);
 
diff -puN include/linux/eventpoll.h~revert-epoll-support-for-disabling-items-and-a-self-test-app include/linux/eventpoll.h
diff -puN tools/testing/selftests/Makefile~revert-epoll-support-for-disabling-items-and-a-self-test-app tools/testing/selftests/Makefile
--- a/tools/testing/selftests/Makefile~revert-epoll-support-for-disabling-items-and-a-self-test-app
+++ a/tools/testing/selftests/Makefile
@@ -1,4 +1,4 @@
-TARGETS = breakpoints kcmp mqueue vm cpu-hotplug memory-hotplug epoll
+TARGETS = breakpoints kcmp mqueue vm cpu-hotplug memory-hotplug
 
 all:
 	for TARGET in $(TARGETS); do \
diff -puN tools/testing/selftests/epoll/Makefile~revert-epoll-support-for-disabling-items-and-a-self-test-app /dev/null
--- a/tools/testing/selftests/epoll/Makefile
+++ /dev/null
@@ -1,11 +0,0 @@
-# Makefile for epoll selftests
-
-all: test_epoll
-%: %.c
-	gcc -pthread -g -o $@ $^
-
-run_tests: all
-	./test_epoll
-
-clean:
-	$(RM) test_epoll
diff -puN tools/testing/selftests/epoll/test_epoll.c~revert-epoll-support-for-disabling-items-and-a-self-test-app /dev/null
--- a/tools/testing/selftests/epoll/test_epoll.c
+++ /dev/null
@@ -1,344 +0,0 @@
-/*
- *  tools/testing/selftests/epoll/test_epoll.c
- *
- *  Copyright 2012 Adobe Systems Incorporated
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  Paton J. Lewis <palewis@adobe.com>
- *
- */
-
-#include <errno.h>
-#include <fcntl.h>
-#include <pthread.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <sys/epoll.h>
-#include <sys/socket.h>
-
-/*
- * A pointer to an epoll_item_private structure will be stored in the epoll
- * item's event structure so that we can get access to the epoll_item_private
- * data after calling epoll_wait:
- */
-struct epoll_item_private {
-	int index;  /* Position of this struct within the epoll_items array. */
-	int fd;
-	uint32_t events;
-	pthread_mutex_t mutex;  /* Guards the following variables... */
-	int stop;
-	int status;  /* Stores any error encountered while handling item. */
-	/* The following variable allows us to test whether we have encountered
-	   a problem while attempting to cancel and delete the associated
-	   event. When the test program exits, 'deleted' should be exactly
-	   one. If it is greater than one, then the failed test reflects a real
-	   world situation where we would have tried to access the epoll item's
-	   private data after deleting it: */
-	int deleted;
-};
-
-struct epoll_item_private *epoll_items;
-
-/*
- * Delete the specified item from the epoll set. In a real-world secneario this
- * is where we would free the associated data structure, but in this testing
- * environment we retain the structure so that we can test for double-deletion:
- */
-void delete_item(int index)
-{
-	__sync_fetch_and_add(&epoll_items[index].deleted, 1);
-}
-
-/*
- * A pointer to a read_thread_data structure will be passed as the argument to
- * each read thread:
- */
-struct read_thread_data {
-	int stop;
-	int status;  /* Indicates any error encountered by the read thread. */
-	int epoll_set;
-};
-
-/*
- * The function executed by the read threads:
- */
-void *read_thread_function(void *function_data)
-{
-	struct read_thread_data *thread_data =
-		(struct read_thread_data *)function_data;
-	struct epoll_event event_data;
-	struct epoll_item_private *item_data;
-	char socket_data;
-
-	/* Handle events until we encounter an error or this thread's 'stop'
-	   condition is set: */
-	while (1) {
-		int result = epoll_wait(thread_data->epoll_set,
-					&event_data,
-					1,	/* Number of desired events */
-					1000);  /* Timeout in ms */
-		if (result < 0) {
-			/* Breakpoints signal all threads. Ignore that while
-			   debugging: */
-			if (errno == EINTR)
-				continue;
-			thread_data->status = errno;
-			return 0;
-		} else if (thread_data->stop)
-			return 0;
-		else if (result == 0)  /* Timeout */
-			continue;
-
-		/* We need the mutex here because checking for the stop
-		   condition and re-enabling the epoll item need to be done
-		   together as one atomic operation when EPOLL_CTL_DISABLE is
-		   available: */
-		item_data = (struct epoll_item_private *)event_data.data.ptr;
-		pthread_mutex_lock(&item_data->mutex);
-
-		/* Remove the item from the epoll set if we want to stop
-		   handling that event: */
-		if (item_data->stop)
-			delete_item(item_data->index);
-		else {
-			/* Clear the data that was written to the other end of
-			   our non-blocking socket: */
-			do {
-				if (read(item_data->fd, &socket_data, 1) < 1) {
-					if ((errno == EAGAIN) ||
-					    (errno == EWOULDBLOCK))
-						break;
-					else
-						goto error_unlock;
-				}
-			} while (item_data->events & EPOLLET);
-
-			/* The item was one-shot, so re-enable it: */
-			event_data.events = item_data->events;
-			if (epoll_ctl(thread_data->epoll_set,
-						  EPOLL_CTL_MOD,
-						  item_data->fd,
-						  &event_data) < 0)
-				goto error_unlock;
-		}
-
-		pthread_mutex_unlock(&item_data->mutex);
-	}
-
-error_unlock:
-	thread_data->status = item_data->status = errno;
-	pthread_mutex_unlock(&item_data->mutex);
-	return 0;
-}
-
-/*
- * A pointer to a write_thread_data structure will be passed as the argument to
- * the write thread:
- */
-struct write_thread_data {
-	int stop;
-	int status;  /* Indicates any error encountered by the write thread. */
-	int n_fds;
-	int *fds;
-};
-
-/*
- * The function executed by the write thread. It writes a single byte to each
- * socket in turn until the stop condition for this thread is set. If writing to
- * a socket would block (i.e. errno was EAGAIN), we leave that socket alone for
- * the moment and just move on to the next socket in the list. We don't care
- * about the order in which we deliver events to the epoll set. In fact we don't
- * care about the data we're writing to the pipes at all; we just want to
- * trigger epoll events:
- */
-void *write_thread_function(void *function_data)
-{
-	const char data = 'X';
-	int index;
-	struct write_thread_data *thread_data =
-		(struct write_thread_data *)function_data;
-	while (!write_thread_data->stop)
-		for (index = 0;
-		     !thread_data->stop && (index < thread_data->n_fds);
-		     ++index)
-			if ((write(thread_data->fds[index], &data, 1) < 1) &&
-				(errno != EAGAIN) &&
-				(errno != EWOULDBLOCK)) {
-				write_thread_data->status = errno;
-				return;
-			}
-}
-
-/*
- * Arguments are currently ignored:
- */
-int main(int argc, char **argv)
-{
-	const int n_read_threads = 100;
-	const int n_epoll_items = 500;
-	int index;
-	int epoll_set = epoll_create1(0);
-	struct write_thread_data write_thread_data = {
-		0, 0, n_epoll_items, malloc(n_epoll_items * sizeof(int))
-	};
-	struct read_thread_data *read_thread_data =
-		malloc(n_read_threads * sizeof(struct read_thread_data));
-	pthread_t *read_threads = malloc(n_read_threads * sizeof(pthread_t));
-	pthread_t write_thread;
-
-	printf("-----------------\n");
-	printf("Runing test_epoll\n");
-	printf("-----------------\n");
-
-	epoll_items = malloc(n_epoll_items * sizeof(struct epoll_item_private));
-
-	if (epoll_set < 0 || epoll_items == 0 || write_thread_data.fds == 0 ||
-		read_thread_data == 0 || read_threads == 0)
-		goto error;
-
-	if (sysconf(_SC_NPROCESSORS_ONLN) < 2) {
-		printf("Error: please run this test on a multi-core system.\n");
-		goto error;
-	}
-
-	/* Create the socket pairs and epoll items: */
-	for (index = 0; index < n_epoll_items; ++index) {
-		int socket_pair[2];
-		struct epoll_event event_data;
-		if (socketpair(AF_UNIX,
-			       SOCK_STREAM | SOCK_NONBLOCK,
-			       0,
-			       socket_pair) < 0)
-			goto error;
-		write_thread_data.fds[index] = socket_pair[0];
-		epoll_items[index].index = index;
-		epoll_items[index].fd = socket_pair[1];
-		if (pthread_mutex_init(&epoll_items[index].mutex, NULL) != 0)
-			goto error;
-		/* We always use EPOLLONESHOT because this test is currently
-		   structured to demonstrate the need for EPOLL_CTL_DISABLE,
-		   which only produces useful information in the EPOLLONESHOT
-		   case (without EPOLLONESHOT, calling epoll_ctl with
-		   EPOLL_CTL_DISABLE will never return EBUSY). If support for
-		   testing events without EPOLLONESHOT is desired, it should
-		   probably be implemented in a separate unit test. */
-		epoll_items[index].events = EPOLLIN | EPOLLONESHOT;
-		if (index < n_epoll_items / 2)
-			epoll_items[index].events |= EPOLLET;
-		epoll_items[index].stop = 0;
-		epoll_items[index].status = 0;
-		epoll_items[index].deleted = 0;
-		event_data.events = epoll_items[index].events;
-		event_data.data.ptr = &epoll_items[index];
-		if (epoll_ctl(epoll_set,
-			      EPOLL_CTL_ADD,
-			      epoll_items[index].fd,
-			      &event_data) < 0)
-			goto error;
-	}
-
-	/* Create and start the read threads: */
-	for (index = 0; index < n_read_threads; ++index) {
-		read_thread_data[index].stop = 0;
-		read_thread_data[index].status = 0;
-		read_thread_data[index].epoll_set = epoll_set;
-		if (pthread_create(&read_threads[index],
-				   NULL,
-				   read_thread_function,
-				   &read_thread_data[index]) != 0)
-			goto error;
-	}
-
-	if (pthread_create(&write_thread,
-			   NULL,
-			   write_thread_function,
-			   &write_thread_data) != 0)
-		goto error;
-
-	/* Cancel all event pollers: */
-#ifdef EPOLL_CTL_DISABLE
-	for (index = 0; index < n_epoll_items; ++index) {
-		pthread_mutex_lock(&epoll_items[index].mutex);
-		++epoll_items[index].stop;
-		if (epoll_ctl(epoll_set,
-			      EPOLL_CTL_DISABLE,
-			      epoll_items[index].fd,
-			      NULL) == 0)
-			delete_item(index);
-		else if (errno != EBUSY) {
-			pthread_mutex_unlock(&epoll_items[index].mutex);
-			goto error;
-		}
-		/* EBUSY means events were being handled; allow the other thread
-		   to delete the item. */
-		pthread_mutex_unlock(&epoll_items[index].mutex);
-	}
-#else
-	for (index = 0; index < n_epoll_items; ++index) {
-		pthread_mutex_lock(&epoll_items[index].mutex);
-		++epoll_items[index].stop;
-		pthread_mutex_unlock(&epoll_items[index].mutex);
-		/* Wait in case a thread running read_thread_function is
-		   currently executing code between epoll_wait and
-		   pthread_mutex_lock with this item. Note that a longer delay
-		   would make double-deletion less likely (at the expense of
-		   performance), but there is no guarantee that any delay would
-		   ever be sufficient. Note also that we delete all event
-		   pollers at once for testing purposes, but in a real-world
-		   environment we are likely to want to be able to cancel event
-		   pollers at arbitrary times. Therefore we can't improve this
-		   situation by just splitting this loop into two loops
-		   (i.e. signal 'stop' for all items, sleep, and then delete all
-		   items). We also can't fix the problem via EPOLL_CTL_DEL
-		   because that command can't prevent the case where some other
-		   thread is executing read_thread_function within the region
-		   mentioned above: */
-		usleep(1);
-		pthread_mutex_lock(&epoll_items[index].mutex);
-		if (!epoll_items[index].deleted)
-			delete_item(index);
-		pthread_mutex_unlock(&epoll_items[index].mutex);
-	}
-#endif
-
-	/* Shut down the read threads: */
-	for (index = 0; index < n_read_threads; ++index)
-		__sync_fetch_and_add(&read_thread_data[index].stop, 1);
-	for (index = 0; index < n_read_threads; ++index) {
-		if (pthread_join(read_threads[index], NULL) != 0)
-			goto error;
-		if (read_thread_data[index].status)
-			goto error;
-	}
-
-	/* Shut down the write thread: */
-	__sync_fetch_and_add(&write_thread_data.stop, 1);
-	if ((pthread_join(write_thread, NULL) != 0) || write_thread_data.status)
-		goto error;
-
-	/* Check for final error conditions: */
-	for (index = 0; index < n_epoll_items; ++index) {
-		if (epoll_items[index].status != 0)
-			goto error;
-		if (pthread_mutex_destroy(&epoll_items[index].mutex) < 0)
-			goto error;
-	}
-	for (index = 0; index < n_epoll_items; ++index)
-		if (epoll_items[index].deleted != 1) {
-			printf("Error: item data deleted %1d times.\n",
-				   epoll_items[index].deleted);
-			goto error;
-		}
-
-	printf("[PASS]\n");
-	return 0;
-
- error:
-	printf("[FAIL]\n");
-	return errno;
-}
diff -puN include/uapi/linux/eventpoll.h~revert-epoll-support-for-disabling-items-and-a-self-test-app include/uapi/linux/eventpoll.h
--- a/include/uapi/linux/eventpoll.h~revert-epoll-support-for-disabling-items-and-a-self-test-app
+++ a/include/uapi/linux/eventpoll.h
@@ -25,7 +25,6 @@
 #define EPOLL_CTL_ADD 1
 #define EPOLL_CTL_DEL 2
 #define EPOLL_CTL_MOD 3
-#define EPOLL_CTL_DISABLE 4
 
 /*
  * Request the handling of system wakeup events so as to prevent system suspends
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

pidns-remove-recursion-from-free_pid_ns-v5-fix.patch
revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

