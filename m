From: akpm@linux-foundation.org
Subject: - random-add-async-notification-support-to-dev-random.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:48:29 -0700
Message-ID: <200804300548.m3U5mTlN029888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760574AbYD3GMk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mpm@selenic.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     random: add async notification support to /dev/random
has been removed from the -mm tree.  Its filename was
     random-add-async-notification-support-to-dev-random.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: random: add async notification support to /dev/random
From: Jeff Dike <jdike@addtoit.com>

Add async notification support to /dev/random.

A little test case is below.  Without this patch, you get:

$ ./async-random
Drained the pool
Found more randomness

With it, you get:

$ ./async-random
Drained the pool
SIGIO
Found more randomness

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <errno.h>
#include <fcntl.h>

static void handler(int sig)
{
        printf("SIGIO\n");
}

int main(int argc, char **argv)
{
        int fd, n, err, flags;

        if(signal(SIGIO, handler) < 0){
                perror("setting SIGIO handler");
                exit(1);
        }

        fd = open("/dev/random", O_RDONLY);
        if(fd < 0){
                perror("open");
                exit(1);
        }

        flags = fcntl(fd, F_GETFL);
        if (flags < 0){
                perror("getting flags");
                exit(1);
        }

        flags |= O_NONBLOCK;
        if (fcntl(fd, F_SETFL, flags) < 0){
                perror("setting flags");
                exit(1);
        }

        while((err = read(fd, &n, sizeof(n))) > 0) ;

        if(err == 0){
                printf("random returned 0\n");
                exit(1);
        }
        else if(errno != EAGAIN){
                perror("read");
                exit(1);
        }

        flags |= O_ASYNC;
        if (fcntl(fd, F_SETFL, flags) < 0){
                perror("setting flags");
                exit(1);
        }

        if (fcntl(fd, F_SETOWN, getpid()) < 0) {
                perror("Setting SIGIO");
                exit(1);
        }

        printf("Drained the pool\n");
        read(fd, &n, sizeof(n));
        printf("Found more randomness\n");

        return(0);
}

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff -puN drivers/char/random.c~random-add-async-notification-support-to-dev-random drivers/char/random.c
--- a/drivers/char/random.c~random-add-async-notification-support-to-dev-random
+++ a/drivers/char/random.c
@@ -370,6 +370,7 @@ static struct poolinfo {
  */
 static DECLARE_WAIT_QUEUE_HEAD(random_read_wait);
 static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
+static struct fasync_struct *fasync;
 
 #if 0
 static int debug;
@@ -533,8 +534,11 @@ static void credit_entropy_bits(struct e
 		r->entropy_count = r->poolinfo->POOLBITS;
 
 	/* should we wake readers? */
-	if (r == &input_pool && r->entropy_count >= random_read_wakeup_thresh)
+	if (r == &input_pool &&
+	    r->entropy_count >= random_read_wakeup_thresh) {
 		wake_up_interruptible(&random_read_wait);
+		kill_fasync(&fasync, SIGIO, POLL_IN);
+	}
 
 	spin_unlock_irqrestore(&r->lock, flags);
 }
@@ -742,8 +746,10 @@ static size_t account(struct entropy_sto
 		else
 			r->entropy_count = reserved;
 
-		if (r->entropy_count < random_write_wakeup_thresh)
+		if (r->entropy_count < random_write_wakeup_thresh) {
 			wake_up_interruptible(&random_write_wait);
+			kill_fasync(&fasync, SIGIO, POLL_OUT);
+		}
 	}
 
 	DEBUG_ENT("debiting %d entropy credits from %s%s\n",
@@ -1100,17 +1106,31 @@ static long random_ioctl(struct file *f,
 	}
 }
 
+static int random_fasync(int fd, struct file *filp, int on)
+{
+	return fasync_helper(fd, filp, on, &fasync);
+}
+
+static int random_release(struct inode *inode, struct file *filp)
+{
+	return fasync_helper(-1, filp, 0, &fasync);
+}
+
 const struct file_operations random_fops = {
 	.read  = random_read,
 	.write = random_write,
 	.poll  = random_poll,
 	.unlocked_ioctl = random_ioctl,
+	.fasync = random_fasync,
+	.release = random_release,
 };
 
 const struct file_operations urandom_fops = {
 	.read  = urandom_read,
 	.write = random_write,
 	.unlocked_ioctl = random_ioctl,
+	.fasync = random_fasync,
+	.release = random_release,
 };
 
 /***************************************************************
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
serial167-switch-to-int-put_char-method.patch
asm-futexh-should-include-linux-uaccessh.patch
rename-div64_64-to-div64_u64.patch

