From: akpm@linux-foundation.org
Subject: + mm-mempolicy-remove-unneeded-functions-for-uma-configs.patch
 added to -mm tree
Date: Mon, 25 Nov 2013 17:17:41 -0800
Message-ID: <5293f6b5.reQ1M9c73qYSREaz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab3KZBRm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Nov 2013 20:17:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, hannes@cmpxchg.org, rientjes@google.com

Subject: + mm-mempolicy-remove-unneeded-functions-for-uma-configs.patch added to -mm tree
To: rientjes@google.com,hannes@cmpxchg.org,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 25 Nov 2013 17:17:41 -0800


The patch titled
     Subject: mm, mempolicy: remove unneeded functions for UMA configs
has been added to the -mm tree.  Its filename is
     mm-mempolicy-remove-unneeded-functions-for-uma-configs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-remove-unneeded-functions-for-uma-configs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-remove-unneeded-functions-for-uma-configs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, mempolicy: remove unneeded functions for UMA configs

Mempolicies only exist for CONFIG_NUMA configurations.  Therefore, a
certain class of functions are unneeded in configurations where
CONFIG_NUMA is disabled such as functions that duplicate existing
mempolicies, lookup existing policies, set certain mempolicy traits, or
test mempolicies for certain attributes.

Remove the unneeded functions so that any future callers get a compile-
time error and protect their code with CONFIG_NUMA as required.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |   32 --------------------------------
 1 file changed, 32 deletions(-)

diff -puN include/linux/mempolicy.h~mm-mempolicy-remove-unneeded-functions-for-uma-configs include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-mempolicy-remove-unneeded-functions-for-uma-configs
+++ a/include/linux/mempolicy.h
@@ -211,20 +211,8 @@ static inline void mpol_get(struct mempo
 {
 }
 
-static inline struct mempolicy *mpol_dup(struct mempolicy *old)
-{
-	return NULL;
-}
-
 struct shared_policy {};
 
-static inline int mpol_set_shared_policy(struct shared_policy *info,
-					struct vm_area_struct *vma,
-					struct mempolicy *new)
-{
-	return -EINVAL;
-}
-
 static inline void mpol_shared_policy_init(struct shared_policy *sp,
 						struct mempolicy *mpol)
 {
@@ -234,12 +222,6 @@ static inline void mpol_free_shared_poli
 {
 }
 
-static inline struct mempolicy *
-mpol_shared_policy_lookup(struct shared_policy *sp, unsigned long idx)
-{
-	return NULL;
-}
-
 #define vma_policy(vma) NULL
 
 static inline int
@@ -266,10 +248,6 @@ static inline void mpol_rebind_mm(struct
 {
 }
 
-static inline void mpol_fix_fork_child_flag(struct task_struct *p)
-{
-}
-
 static inline struct zonelist *huge_zonelist(struct vm_area_struct *vma,
 				unsigned long addr, gfp_t gfp_flags,
 				struct mempolicy **mpol, nodemask_t **nodemask)
@@ -284,12 +262,6 @@ static inline bool init_nodemask_of_memp
 	return false;
 }
 
-static inline bool mempolicy_nodemask_intersects(struct task_struct *tsk,
-			const nodemask_t *mask)
-{
-	return false;
-}
-
 static inline int do_migrate_pages(struct mm_struct *mm, const nodemask_t *from,
 				   const nodemask_t *to, int flags)
 {
@@ -307,10 +279,6 @@ static inline int mpol_parse_str(char *s
 }
 #endif
 
-static inline void mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol)
-{
-}
