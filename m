Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 769B3C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 605F061D09
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbhF2CjC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:39:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231912AbhF2CjB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:39:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00B4D61D04;
        Tue, 29 Jun 2021 02:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934194;
        bh=144Vo/3ryVW1dFsDuX+q+7vfyk2Cb0FMoIxyBacGCQI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZaCRWA2a41Vz6RSQewfGPVZD/Ztl5Mgw8Fz/iTkD1WHT4wAjqdhH25irje9VyvJ1s
         Mh9nMeigoEeFJdd4456trvmd1If2X9L3reW8DkTiHpMZqmbQV6Go6GWAUtf/90UwYC
         t+fO3l8AUEbodyDT7HX8H3AL/QRpJXBEM6oyWPto=
Date:   Mon, 28 Jun 2021 19:36:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, hughd@google.com,
        jack@suse.cz, jannh@google.com, jgg@nvidia.com,
        jhubbard@nvidia.com, kirill@shutemov.name, ktkhai@virtuozzo.com,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        oleg@redhat.com, peterx@redhat.com, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 063/192] mm/gup_benchmark: support threading
Message-ID: <20210629023633.rgmfM5xKC%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: mm/gup_benchmark: support threading

Patch series "mm/gup: Fix pin page write cache bouncing on has_pinned", v2.

This series contains 3 patches, the 1st one enables threading for
gup_benchmark in the kselftest.  The latter two patches are collected from
Andrea's local branch which can fix write cache bouncing issue with
pinning fast-gup.

To be explicit on the latter two patches:

  - the 2nd patch fixes the perf degrade when introducing has_pinned, then

  - the last patch tries to remove the has_pinned with a bit in mm->flags

For patch 3: originally I think we had a plan to reuse has_pinned into a
counter very soon, however that's not happening at least until today, so
maybe it proves that we can remove it until we really want such a counter
for whatever reason.  As the commit message stated, it saves 4 bytes for
each mm without observable regressions.

Regarding testing: we can reference to the commit message of patch 2 for
some detailed testing with will-is-scale.  Meanwhile I did patch 1 just
because then we can even easily verify the patchset using the existing
kselftest facilities or even regress test it in the future with the repo
if we want.

Below numbers are extra verification tests that I did besides commit
message of patch 2 using the new gup_benchmark and 256 cpus.  Below test
is done on 40 cpus host with Intel(R) Xeon(R) CPU E5-2630 v4 @ 2.20GHz,
and I can get similar result (of course the write cache bouncing get
severe with even more cores).

After patch 1 applied (only test patch, so using old kernel):

  $ sudo chrt -f 1 ./gup_test -a  -m 512 -j 40
  PIN_FAST_BENCHMARK: Time: get:459632 put:5990 us
  PIN_FAST_BENCHMARK: Time: get:461967 put:5840 us
  PIN_FAST_BENCHMARK: Time: get:464521 put:6140 us
  PIN_FAST_BENCHMARK: Time: get:465176 put:7100 us
  PIN_FAST_BENCHMARK: Time: get:465960 put:6733 us
  PIN_FAST_BENCHMARK: Time: get:465324 put:6781 us
  PIN_FAST_BENCHMARK: Time: get:466018 put:7130 us
  PIN_FAST_BENCHMARK: Time: get:466362 put:7118 us
  PIN_FAST_BENCHMARK: Time: get:465118 put:6975 us
  PIN_FAST_BENCHMARK: Time: get:466422 put:6602 us
  PIN_FAST_BENCHMARK: Time: get:465791 put:6818 us
  PIN_FAST_BENCHMARK: Time: get:467091 put:6298 us
  PIN_FAST_BENCHMARK: Time: get:467694 put:5432 us
  PIN_FAST_BENCHMARK: Time: get:469575 put:5581 us
  PIN_FAST_BENCHMARK: Time: get:468124 put:6055 us
  PIN_FAST_BENCHMARK: Time: get:468877 put:6720 us
  PIN_FAST_BENCHMARK: Time: get:467212 put:4961 us
  PIN_FAST_BENCHMARK: Time: get:467834 put:6697 us
  PIN_FAST_BENCHMARK: Time: get:470778 put:6398 us
  PIN_FAST_BENCHMARK: Time: get:469788 put:6310 us
  PIN_FAST_BENCHMARK: Time: get:488277 put:7113 us
  PIN_FAST_BENCHMARK: Time: get:486613 put:7085 us
  PIN_FAST_BENCHMARK: Time: get:486940 put:7202 us
  PIN_FAST_BENCHMARK: Time: get:488728 put:7101 us
  PIN_FAST_BENCHMARK: Time: get:487570 put:7327 us
  PIN_FAST_BENCHMARK: Time: get:489260 put:7027 us
  PIN_FAST_BENCHMARK: Time: get:488846 put:6866 us
  PIN_FAST_BENCHMARK: Time: get:488521 put:6745 us
  PIN_FAST_BENCHMARK: Time: get:489950 put:6459 us
  PIN_FAST_BENCHMARK: Time: get:489777 put:6617 us
  PIN_FAST_BENCHMARK: Time: get:488224 put:6591 us
  PIN_FAST_BENCHMARK: Time: get:488644 put:6477 us
  PIN_FAST_BENCHMARK: Time: get:488754 put:6711 us
  PIN_FAST_BENCHMARK: Time: get:488875 put:6743 us
  PIN_FAST_BENCHMARK: Time: get:489290 put:6657 us
  PIN_FAST_BENCHMARK: Time: get:490264 put:6684 us
  PIN_FAST_BENCHMARK: Time: get:489631 put:6737 us
  PIN_FAST_BENCHMARK: Time: get:488434 put:6655 us
  PIN_FAST_BENCHMARK: Time: get:492213 put:6297 us
  PIN_FAST_BENCHMARK: Time: get:491124 put:6173 us

After the whole series applied (new fixed kernel):

  $ sudo chrt -f 1 ./gup_test -a  -m 512 -j 40
  PIN_FAST_BENCHMARK: Time: get:82038 put:7041 us
  PIN_FAST_BENCHMARK: Time: get:82144 put:6817 us
  PIN_FAST_BENCHMARK: Time: get:83417 put:6674 us
  PIN_FAST_BENCHMARK: Time: get:82540 put:6594 us
  PIN_FAST_BENCHMARK: Time: get:83214 put:6681 us
  PIN_FAST_BENCHMARK: Time: get:83444 put:6889 us
  PIN_FAST_BENCHMARK: Time: get:83194 put:7499 us
  PIN_FAST_BENCHMARK: Time: get:84876 put:7369 us
  PIN_FAST_BENCHMARK: Time: get:86092 put:10289 us
  PIN_FAST_BENCHMARK: Time: get:86153 put:10415 us
  PIN_FAST_BENCHMARK: Time: get:85026 put:7751 us
  PIN_FAST_BENCHMARK: Time: get:85458 put:7944 us
  PIN_FAST_BENCHMARK: Time: get:85735 put:8154 us
  PIN_FAST_BENCHMARK: Time: get:85851 put:8299 us
  PIN_FAST_BENCHMARK: Time: get:86323 put:9617 us
  PIN_FAST_BENCHMARK: Time: get:86288 put:10496 us
  PIN_FAST_BENCHMARK: Time: get:87697 put:9346 us
  PIN_FAST_BENCHMARK: Time: get:87980 put:8382 us
  PIN_FAST_BENCHMARK: Time: get:88719 put:8400 us
  PIN_FAST_BENCHMARK: Time: get:87616 put:8588 us
  PIN_FAST_BENCHMARK: Time: get:86730 put:9563 us
  PIN_FAST_BENCHMARK: Time: get:88167 put:8673 us
  PIN_FAST_BENCHMARK: Time: get:86844 put:9777 us
  PIN_FAST_BENCHMARK: Time: get:88068 put:11774 us
  PIN_FAST_BENCHMARK: Time: get:86170 put:15676 us
  PIN_FAST_BENCHMARK: Time: get:87967 put:12827 us
  PIN_FAST_BENCHMARK: Time: get:95773 put:7652 us
  PIN_FAST_BENCHMARK: Time: get:87734 put:13650 us
  PIN_FAST_BENCHMARK: Time: get:89833 put:14237 us
  PIN_FAST_BENCHMARK: Time: get:96186 put:8029 us
  PIN_FAST_BENCHMARK: Time: get:95532 put:8886 us
  PIN_FAST_BENCHMARK: Time: get:95351 put:5826 us
  PIN_FAST_BENCHMARK: Time: get:96401 put:8407 us
  PIN_FAST_BENCHMARK: Time: get:96473 put:8287 us
  PIN_FAST_BENCHMARK: Time: get:97177 put:8430 us
  PIN_FAST_BENCHMARK: Time: get:98120 put:5263 us
  PIN_FAST_BENCHMARK: Time: get:96271 put:7757 us
  PIN_FAST_BENCHMARK: Time: get:99628 put:10467 us
  PIN_FAST_BENCHMARK: Time: get:99344 put:10045 us
  PIN_FAST_BENCHMARK: Time: get:94212 put:15485 us

Summary:

  Old kernel: 477729.97 (+-3.79%)
  New kernel:  89144.65 (+-11.76%)


This patch (of 3):

Add a new parameter "-j N" to support concurrent gup test.

Link: https://lkml.kernel.org/r/20210507150553.208763-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20210507150553.208763-2-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Kirill Shutemov <kirill@shutemov.name>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/gup_test.c |   96 ++++++++++++++++--------
 1 file changed, 65 insertions(+), 31 deletions(-)

--- a/tools/testing/selftests/vm/gup_test.c~mm-gup_benchmark-support-threading
+++ a/tools/testing/selftests/vm/gup_test.c
@@ -6,6 +6,8 @@
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/types.h>
+#include <pthread.h>
+#include <assert.h>
 #include "../../../../mm/gup_test.h"
 
 #define MB (1UL << 20)
@@ -15,6 +17,12 @@
 #define FOLL_WRITE	0x01	/* check pte is writable */
 #define FOLL_TOUCH	0x02	/* mark page accessed */
 
+static unsigned long cmd = GUP_FAST_BENCHMARK;
+static int gup_fd, repeats = 1;
+static unsigned long size = 128 * MB;
+/* Serialize prints */
+static pthread_mutex_t print_mutex = PTHREAD_MUTEX_INITIALIZER;
+
 static char *cmd_to_str(unsigned long cmd)
 {
 	switch (cmd) {
@@ -34,17 +42,55 @@ static char *cmd_to_str(unsigned long cm
 	return "Unknown command";
 }
 
+void *gup_thread(void *data)
+{
+	struct gup_test gup = *(struct gup_test *)data;
+	int i;
+
+	/* Only report timing information on the *_BENCHMARK commands: */
+	if ((cmd == PIN_FAST_BENCHMARK) || (cmd == GUP_FAST_BENCHMARK) ||
+	     (cmd == PIN_LONGTERM_BENCHMARK)) {
+		for (i = 0; i < repeats; i++) {
+			gup.size = size;
+			if (ioctl(gup_fd, cmd, &gup))
+				perror("ioctl"), exit(1);
+
+			pthread_mutex_lock(&print_mutex);
+			printf("%s: Time: get:%lld put:%lld us",
+			       cmd_to_str(cmd), gup.get_delta_usec,
+			       gup.put_delta_usec);
+			if (gup.size != size)
+				printf(", truncated (size: %lld)", gup.size);
+			printf("\n");
+			pthread_mutex_unlock(&print_mutex);
+		}
+	} else {
+		gup.size = size;
+		if (ioctl(gup_fd, cmd, &gup)) {
+			perror("ioctl");
+			exit(1);
+		}
+
+		pthread_mutex_lock(&print_mutex);
+		printf("%s: done\n", cmd_to_str(cmd));
+		if (gup.size != size)
+			printf("Truncated (size: %lld)\n", gup.size);
+		pthread_mutex_unlock(&print_mutex);
+	}
+
+	return NULL;
+}
+
 int main(int argc, char **argv)
 {
 	struct gup_test gup = { 0 };
-	unsigned long size = 128 * MB;
-	int i, fd, filed, opt, nr_pages = 1, thp = -1, repeats = 1, write = 1;
-	unsigned long cmd = GUP_FAST_BENCHMARK;
+	int filed, i, opt, nr_pages = 1, thp = -1, write = 1, nthreads = 1, ret;
 	int flags = MAP_PRIVATE, touch = 0;
 	char *file = "/dev/zero";
+	pthread_t *tid;
 	char *p;
 
-	while ((opt = getopt(argc, argv, "m:r:n:F:f:abctTLUuwWSHpz")) != -1) {
+	while ((opt = getopt(argc, argv, "m:r:n:F:f:abcj:tTLUuwWSHpz")) != -1) {
 		switch (opt) {
 		case 'a':
 			cmd = PIN_FAST_BENCHMARK;
@@ -74,6 +120,9 @@ int main(int argc, char **argv)
 			/* strtol, so you can pass flags in hex form */
 			gup.gup_flags = strtol(optarg, 0, 0);
 			break;
+		case 'j':
+			nthreads = atoi(optarg);
+			break;
 		case 'm':
 			size = atoi(optarg) * MB;
 			break;
@@ -154,8 +203,8 @@ int main(int argc, char **argv)
 	if (write)
 		gup.gup_flags |= FOLL_WRITE;
 
-	fd = open("/sys/kernel/debug/gup_test", O_RDWR);
-	if (fd == -1) {
+	gup_fd = open("/sys/kernel/debug/gup_test", O_RDWR);
+	if (gup_fd == -1) {
 		perror("open");
 		exit(1);
 	}
@@ -185,32 +234,17 @@ int main(int argc, char **argv)
 			p[0] = 0;
 	}
 
-	/* Only report timing information on the *_BENCHMARK commands: */
-	if ((cmd == PIN_FAST_BENCHMARK) || (cmd == GUP_FAST_BENCHMARK) ||
-	     (cmd == PIN_LONGTERM_BENCHMARK)) {
-		for (i = 0; i < repeats; i++) {
-			gup.size = size;
-			if (ioctl(fd, cmd, &gup))
-				perror("ioctl"), exit(1);
-
-			printf("%s: Time: get:%lld put:%lld us",
-			       cmd_to_str(cmd), gup.get_delta_usec,
-			       gup.put_delta_usec);
-			if (gup.size != size)
-				printf(", truncated (size: %lld)", gup.size);
-			printf("\n");
-		}
-	} else {
-		gup.size = size;
-		if (ioctl(fd, cmd, &gup)) {
-			perror("ioctl");
-			exit(1);
-		}
-
-		printf("%s: done\n", cmd_to_str(cmd));
-		if (gup.size != size)
-			printf("Truncated (size: %lld)\n", gup.size);
+	tid = malloc(sizeof(pthread_t) * nthreads);
+	assert(tid);
+	for (i = 0; i < nthreads; i++) {
+		ret = pthread_create(&tid[i], NULL, gup_thread, &gup);
+		assert(ret == 0);
+	}
+	for (i = 0; i < nthreads; i++) {
+		ret = pthread_join(tid[i], NULL);
+		assert(ret == 0);
 	}
+	free(tid);
 
 	return 0;
 }
_
