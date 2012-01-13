From: akpm@linux-foundation.org
Subject: [folded] epoll-limit-paths-update.patch removed from -mm tree
Date: Thu, 12 Jan 2012 16:45:06 -0800
Message-ID: <20120113004506.BDAC310004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:43029 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673Ab2AMApH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2012 19:45:07 -0500
Received: by ghrr18 with SMTP id r18so123172ghr.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2012 16:45:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@redhat.com, davidel@xmailserver.org, nelhage@ksplice.com, mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: cleanup limit paths
has been removed from the -mm tree.  Its filename was
     epoll-limit-paths-update.patch

This patch was dropped because it was folded into epoll-limit-paths.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jason Baron <jbaron@redhat.com>
Subject: epoll: cleanup limit paths

Cleanups based on Andrew Morton's review:
https://lkml.org/lkml/2011/9/2/356

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: Nelson Elhage <nelhage@ksplice.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff -puN fs/eventpoll.c~epoll-limit-paths-update fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-limit-paths-update
+++ a/fs/eventpoll.c
@@ -202,7 +202,7 @@ struct eventpoll {
 
 	/* used to optimize loop detection check */
 	int visited;
-	struct list_head visitedllink;
+	struct list_head visited_list_link;
 };
 
 /* Wait structure used by the poll hooks */
@@ -262,10 +262,13 @@ static struct kmem_cache *epi_cache __re
 static struct kmem_cache *pwq_cache __read_mostly;
 
 /* Visited nodes during ep_loop_check(), so we can unset them when we finish */
-LIST_HEAD(visited_list);
+static LIST_HEAD(visited_list);
 
-/* Files with newly added links, which need a limit on emanating paths */
-LIST_HEAD(tfile_check_list);
+/*
+ * List of files with newly added links, where we may need to limit the number
+ * of emanating paths. Protected by the epmutex.
+ */
+static LIST_HEAD(tfile_check_list);
 
 #ifdef CONFIG_SYSCTL
 
@@ -941,16 +944,19 @@ static void ep_rbtree_insert(struct even
 
 
 #define PATH_ARR_SIZE 5
-/* These are the number paths of length 1 to 5, that we are allowing to emanate
+/*
+ * These are the number paths of length 1 to 5, that we are allowing to emanate
  * from a single file of interest. For example, we allow 1000 paths of length
  * 1, to emanate from each file of interest. This essentially represents the
  * potential wakeup paths, which need to be limited in order to avoid massive
  * uncontrolled wakeup storms. The common use case should be a single ep which
  * is connected to n file sources. In this case each file source has 1 path
- * of length 1. Thus, the numbers below should be more than sufficient.
+ * of length 1. Thus, the numbers below should be more than sufficient. These
+ * path limits are enforced during an EPOLL_CTL_ADD operation, since a modify
+ * and delete can't add additional paths. Protected by the epmutex.
  */
-int path_limits[PATH_ARR_SIZE] = { 1000, 500, 100, 50, 10 };
-int path_count[PATH_ARR_SIZE];
+static const int path_limits[PATH_ARR_SIZE] = { 1000, 500, 100, 50, 10 };
+static int path_count[PATH_ARR_SIZE];
 
 static int path_count_inc(int nests)
 {
@@ -1396,7 +1402,7 @@ static int ep_loop_check_proc(void *priv
 
 	mutex_lock_nested(&ep->mtx, call_nests + 1);
 	ep->visited = 1;
-	list_add(&ep->visitedllink, &visited_list);
+	list_add(&ep->visited_list_link, &visited_list);
 	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
 		epi = rb_entry(rbp, struct epitem, rbn);
 		if (unlikely(is_file_epoll(epi->ffd.file))) {
@@ -1409,12 +1415,13 @@ static int ep_loop_check_proc(void *priv
 			if (error != 0)
 				break;
 		} else {
-			/* if we've reached a file that is not associated with
-			 * an ep, then then we need to check if the newly added
+			/*
+			 * If we've reached a file that is not associated with
+			 * an ep, then we need to check if the newly added
 			 * links are going to add too many wakeup paths. We do
 			 * this by adding it to the tfile_check_list, if it's
 			 * not already there, and calling reverse_path_check()
-			 * during ep_insert()
+			 * during ep_insert().
 			 */
 			if (list_empty(&epi->ffd.file->f_tfile_llink))
 				list_add(&epi->ffd.file->f_tfile_llink,
@@ -1445,9 +1452,10 @@ static int ep_loop_check(struct eventpol
 	ret = ep_call_nested(&poll_loop_ncalls, EP_MAX_NESTS,
 			      ep_loop_check_proc, file, ep, current);
 	/* clear visited list */
-	list_for_each_entry_safe(ep_cur, ep_next, &visited_list, visitedllink) {
+	list_for_each_entry_safe(ep_cur, ep_next, &visited_list,
+							visited_list_link) {
 		ep_cur->visited = 0;
-		list_del(&ep_cur->visitedllink);
+		list_del(&ep_cur->visited_list_link);
 	}
 	return ret;
 }
_

Patches currently in -mm which might be from jbaron@redhat.com are

origin.patch
epoll-limit-paths.patch

