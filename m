From: akpm@linux-foundation.org
Subject: [merged] userfaultfd-selftests-refactor-statistics.patch
 removed from -mm tree
Date: Tue, 07 Apr 2020 18:58:27 -0700
Message-ID: <20200408015827.gC_kW0W0y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHB63 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:58:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, bgeffon@google.com, bobbypowers@gmail.com, cracauer@cons.org, david@redhat.com, dgilbert@redhat.com, dplotnikov@virtuozzo.com, gokhale2@llnl.gov, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, kirill@shutemov.name, mcfadden8@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, peterx@redhat.com, riel@redhat.com, rppt@linux.vnet.ibm.com, shli@fb.com, xemul@openvz.org


The patch titled
     Subject: userfaultfd: selftests: refactor statistics
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftests-refactor-statistics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: userfaultfd: selftests: refactor statistics

Introduce uffd_stats structure for statistics of the self test, at the
same time refactor the code to always pass in the uffd_stats for either
read() or poll() typed fault handling threads instead of using two
different ways to return the statistic results.  No functional change.

With the new structure, it's very easy to introduce new statistics.

Link: http://lkml.kernel.org/r/20200220163112.11409-19-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Bobby Powers <bobbypowers@gmail.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Martin Cracauer <cracauer@cons.org>
Cc: Marty McFadden <mcfadden8@llnl.gov>
Cc: Maya Gokhale <gokhale2@llnl.gov>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   76 +++++++++++++--------
 1 file changed, 49 insertions(+), 27 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-refactor-statistics
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -86,6 +86,12 @@ static char *area_src, *area_src_alias,
 static char *zeropage;
 pthread_attr_t attr;
 
+/* Userfaultfd test statistics */
+struct uffd_stats {
+	int cpu;
+	unsigned long missing_faults;
+};
+
 /* pthread_mutex_t starts at page offset 0 */
 #define area_mutex(___area, ___nr)					\
 	((pthread_mutex_t *) ((___area) + (___nr)*page_size))
@@ -125,6 +131,17 @@ static void usage(void)
 	exit(1);
 }
 
+static void uffd_stats_reset(struct uffd_stats *uffd_stats,
+			     unsigned long n_cpus)
+{
+	int i;
+
+	for (i = 0; i < n_cpus; i++) {
+		uffd_stats[i].cpu = i;
+		uffd_stats[i].missing_faults = 0;
+	}
+}
+
 static int anon_release_pages(char *rel_area)
 {
 	int ret = 0;
@@ -467,8 +484,8 @@ static int uffd_read_msg(int ufd, struct
 	return 0;
 }
 
-/* Return 1 if page fault handled by us; otherwise 0 */
-static int uffd_handle_page_fault(struct uffd_msg *msg)
+static void uffd_handle_page_fault(struct uffd_msg *msg,
+				   struct uffd_stats *stats)
 {
 	unsigned long offset;
 
@@ -483,18 +500,19 @@ static int uffd_handle_page_fault(struct
 	offset = (char *)(unsigned long)msg->arg.pagefault.address - area_dst;
 	offset &= ~(page_size-1);
 
-	return copy_page(uffd, offset);
+	if (copy_page(uffd, offset))
+		stats->missing_faults++;
 }
 
 static void *uffd_poll_thread(void *arg)
 {
-	unsigned long cpu = (unsigned long) arg;
+	struct uffd_stats *stats = (struct uffd_stats *)arg;
+	unsigned long cpu = stats->cpu;
 	struct pollfd pollfd[2];
 	struct uffd_msg msg;
 	struct uffdio_register uffd_reg;
 	int ret;
 	char tmp_chr;
-	unsigned long userfaults = 0;
 
 	pollfd[0].fd = uffd;
 	pollfd[0].events = POLLIN;
@@ -524,7 +542,7 @@ static void *uffd_poll_thread(void *arg)
 				msg.event), exit(1);
 			break;
 		case UFFD_EVENT_PAGEFAULT:
-			userfaults += uffd_handle_page_fault(&msg);
+			uffd_handle_page_fault(&msg, stats);
 			break;
 		case UFFD_EVENT_FORK:
 			close(uffd);
@@ -543,28 +561,27 @@ static void *uffd_poll_thread(void *arg)
 			break;
 		}
 	}
-	return (void *)userfaults;
+
+	return NULL;
 }
 
 pthread_mutex_t uffd_read_mutex = PTHREAD_MUTEX_INITIALIZER;
 
 static void *uffd_read_thread(void *arg)
 {
-	unsigned long *this_cpu_userfaults;
+	struct uffd_stats *stats = (struct uffd_stats *)arg;
 	struct uffd_msg msg;
 
-	this_cpu_userfaults = (unsigned long *) arg;
-	*this_cpu_userfaults = 0;
-
 	pthread_mutex_unlock(&uffd_read_mutex);
 	/* from here cancellation is ok */
 
 	for (;;) {
 		if (uffd_read_msg(uffd, &msg))
 			continue;
-		(*this_cpu_userfaults) += uffd_handle_page_fault(&msg);
+		uffd_handle_page_fault(&msg, stats);
 	}
-	return (void *)NULL;
+
+	return NULL;
 }
 
 static void *background_thread(void *arg)
@@ -580,13 +597,12 @@ static void *background_thread(void *arg
 	return NULL;
 }
 
-static int stress(unsigned long *userfaults)
+static int stress(struct uffd_stats *uffd_stats)
 {
 	unsigned long cpu;
 	pthread_t locking_threads[nr_cpus];
 	pthread_t uffd_threads[nr_cpus];
 	pthread_t background_threads[nr_cpus];
-	void **_userfaults = (void **) userfaults;
 
 	finished = 0;
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
@@ -595,12 +611,13 @@ static int stress(unsigned long *userfau
 			return 1;
 		if (bounces & BOUNCE_POLL) {
 			if (pthread_create(&uffd_threads[cpu], &attr,
-					   uffd_poll_thread, (void *)cpu))
+					   uffd_poll_thread,
+					   (void *)&uffd_stats[cpu]))
 				return 1;
 		} else {
 			if (pthread_create(&uffd_threads[cpu], &attr,
 					   uffd_read_thread,
-					   &_userfaults[cpu]))
+					   (void *)&uffd_stats[cpu]))
 				return 1;
 			pthread_mutex_lock(&uffd_read_mutex);
 		}
@@ -637,7 +654,8 @@ static int stress(unsigned long *userfau
 				fprintf(stderr, "pipefd write error\n");
 				return 1;
 			}
-			if (pthread_join(uffd_threads[cpu], &_userfaults[cpu]))
+			if (pthread_join(uffd_threads[cpu],
+					 (void *)&uffd_stats[cpu]))
 				return 1;
 		} else {
 			if (pthread_cancel(uffd_threads[cpu]))
@@ -908,11 +926,11 @@ static int userfaultfd_events_test(void)
 {
 	struct uffdio_register uffdio_register;
 	unsigned long expected_ioctls;
-	unsigned long userfaults;
 	pthread_t uffd_mon;
 	int err, features;
 	pid_t pid;
 	char c;
+	struct uffd_stats stats = { 0 };
 
 	printf("testing events (fork, remap, remove): ");
 	fflush(stdout);
@@ -939,7 +957,7 @@ static int userfaultfd_events_test(void)
 			"unexpected missing ioctl for anon memory\n"),
 			exit(1);
 
-	if (pthread_create(&uffd_mon, &attr, uffd_poll_thread, NULL))
+	if (pthread_create(&uffd_mon, &attr, uffd_poll_thread, &stats))
 		perror("uffd_poll_thread create"), exit(1);
 
 	pid = fork();
@@ -955,13 +973,13 @@ static int userfaultfd_events_test(void)
 
 	if (write(pipefd[1], &c, sizeof(c)) != sizeof(c))
 		perror("pipe write"), exit(1);
-	if (pthread_join(uffd_mon, (void **)&userfaults))
+	if (pthread_join(uffd_mon, NULL))
 		return 1;
 
 	close(uffd);
-	printf("userfaults: %ld\n", userfaults);
+	printf("userfaults: %ld\n", stats.missing_faults);
 
-	return userfaults != nr_pages;
+	return stats.missing_faults != nr_pages;
 }
 
 static int userfaultfd_sig_test(void)
@@ -973,6 +991,7 @@ static int userfaultfd_sig_test(void)
 	int err, features;
 	pid_t pid;
 	char c;
+	struct uffd_stats stats = { 0 };
 
 	printf("testing signal delivery: ");
 	fflush(stdout);
@@ -1004,7 +1023,7 @@ static int userfaultfd_sig_test(void)
 	if (uffd_test_ops->release_pages(area_dst))
 		return 1;
 
-	if (pthread_create(&uffd_mon, &attr, uffd_poll_thread, NULL))
+	if (pthread_create(&uffd_mon, &attr, uffd_poll_thread, &stats))
 		perror("uffd_poll_thread create"), exit(1);
 
 	pid = fork();
@@ -1030,6 +1049,7 @@ static int userfaultfd_sig_test(void)
 	close(uffd);
 	return userfaults != 0;
 }
+
 static int userfaultfd_stress(void)
 {
 	void *area;
@@ -1038,7 +1058,7 @@ static int userfaultfd_stress(void)
 	struct uffdio_register uffdio_register;
 	unsigned long cpu;
 	int err;
-	unsigned long userfaults[nr_cpus];
+	struct uffd_stats uffd_stats[nr_cpus];
 
 	uffd_test_ops->allocate_area((void **)&area_src);
 	if (!area_src)
@@ -1167,8 +1187,10 @@ static int userfaultfd_stress(void)
 		if (uffd_test_ops->release_pages(area_dst))
 			return 1;
 
+		uffd_stats_reset(uffd_stats, nr_cpus);
+
 		/* bounce pass */
-		if (stress(userfaults))
+		if (stress(uffd_stats))
 			return 1;
 
 		/* unregister */
@@ -1211,7 +1233,7 @@ static int userfaultfd_stress(void)
 
 		printf("userfaults:");
 		for (cpu = 0; cpu < nr_cpus; cpu++)
-			printf(" %lu", userfaults[cpu]);
+			printf(" %lu", uffd_stats[cpu].missing_faults);
 		printf("\n");
 	}
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-mempolicy-allow-lookup_node-to-handle-fatal-signal.patch
mm-gup-mark-lock-taken-only-after-a-successful-retake.patch
