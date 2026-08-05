Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302B71A682E
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 16:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785948053; cv=none; b=XnvL4nwGu/6hcgnqQu8qp0PQrfHkrBzo99mVQSxaWPRpkMMaLBiAv1xqTMC4tjCuFDmy6obN9pfFLRTmNrbGAWcQn8pCJx7wl5XHcpf1fn634LsFd4WkwisjLMOh7gxh8C+sge7FjNOVbdTptFSRNsVeSlRyxRSetOBPdkKUtgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785948053; c=relaxed/simple;
	bh=vsz7uya3MtNcnNjom92wuQineVUj/uxa4IJUpdDCXu4=;
	h=Date:To:From:Subject:Message-Id; b=IHMT7TEL/34WLBxPkBEYhL59T85fU9jCPJeblpv+PZr1OnY85s2NadCMhp6TgE4Wx5GV9P7VAkaSwIdalDVApEbxT9dbXc+axR7FNdflQ5P2B4nVf0RE42FssZPzrk8Pkk2l06/4eCITp5JrEqC0xA0U00/uoBAd+Rz/Oz0wIpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lv/ZeRpl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lv/ZeRpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937901F000E9;
	Wed,  5 Aug 2026 16:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785948051;
	bh=Ek7eX57AYcndALoHO6sDKOtXEbbHL40gpu0u+wvS6Po=;
	h=Date:To:From:Subject;
	b=Lv/ZeRplPCBPhkMJjk8z9S3IomMDlAaG+gRE1q+wDDtXFnhZwRucUVUujSqGAdutN
	 ZesYzeFc9JnhGXPtEf6NKb4F8wt4KFWoDqmuiZdU9Oz8R+wWRxJdBXG/X58uGbTaJf
	 neThbBdsONwa11cc4hG+NT81H3XQcaIGfdRCzJN4=
Date: Wed, 05 Aug 2026 09:40:51 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,vbabka@kernel.org,surenb@google.com,si.yanteng@linux.dev,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,dzm91@hust.edu.cn,david@kernel.org,corbet@lwn.net,chengming.zhou@linux.dev,alexs@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-update-comments-and-docs-to-reference-folio-mapping.patch added to mm-unstable branch
Message-Id: <20260805164051.937901F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ksm: update comments and docs to reference folio->mapping
has been added to the -mm mm-unstable branch.  Its filename is
     ksm-update-comments-and-docs-to-reference-folio-mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-update-comments-and-docs-to-reference-folio-mapping.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: ksm: update comments and docs to reference folio->mapping
Date: Wed, 5 Aug 2026 18:59:07 +0800

The KSM code already stores and checks the stable node key via
folio->mapping, but the comment in ksm_get_folio() and the reverse mapping
documentation in ksm.rst still refer to page->mapping.

This is a pure wording update to match the folio-based implementation.  No
functional change is intended.

Link: https://lore.kernel.org/20260805105927.41987-1-hongfu.li@linux.dev
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Xu Xin <xu.xin16@zte.com.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Cc: Alex Shi <alexs@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yanteng Si <si.yanteng@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/ksm.rst                    |    4 ++--
 Documentation/translations/zh_CN/mm/ksm.rst |    4 ++--
 mm/ksm.c                                    |    7 +++----
 3 files changed, 7 insertions(+), 8 deletions(-)

--- a/Documentation/mm/ksm.rst~ksm-update-comments-and-docs-to-reference-folio-mapping
+++ a/Documentation/mm/ksm.rst
@@ -24,13 +24,13 @@ tree.
 
 If a KSM page is shared between less than ``max_page_sharing`` VMAs,
 the node of the stable tree that represents such KSM page points to a
-list of struct ksm_rmap_item and the ``page->mapping`` of the
+list of struct ksm_rmap_item and the ``folio->mapping`` of the
 KSM page points to the stable tree node.
 
 When the sharing passes this threshold, KSM adds a second dimension to
 the stable tree. The tree node becomes a "chain" that links one or
 more "dups". Each "dup" keeps reverse mapping information for a KSM
-page with ``page->mapping`` pointing to that "dup".
+page with ``folio->mapping`` pointing to that "dup".
 
 Every "chain" and all "dups" linked into a "chain" enforce the
 invariant that they represent the same write protected memory content,
--- a/Documentation/translations/zh_CN/mm/ksm.rst~ksm-update-comments-and-docs-to-reference-folio-mapping
+++ a/Documentation/translations/zh_CN/mm/ksm.rst
@@ -31,10 +31,10 @@ KSM维护着稳定树中的KSM页的逆�
 
 当KSM页面的共享数小于 ``max_page_sharing`` 的虚拟内存区域(VMAs)时，则代表了
 KSM页的稳定树其中的节点指向了一个ksm_rmap_item结构体类型的列表。同时，这个KSM页
-的 ``page->mapping`` 指向了该稳定树节点。
+的 ``folio->mapping`` 指向了该稳定树节点。
 
 如果共享数超过了阈值，KSM将给稳定树添加第二个维度。稳定树就变成链接一个或多
-个稳定树"副本"的"链"。每个副本都保留KSM页的逆映射信息，其中 ``page->mapping``
+个稳定树"副本"的"链"。每个副本都保留KSM页的逆映射信息，其中 ``folio->mapping``
 指向该"副本"。
 
 每个链以及链接到该链中的所有"副本"强制不变的是，它们代表了相同的写保护内存
--- a/mm/ksm.c~ksm-update-comments-and-docs-to-reference-folio-mapping
+++ a/mm/ksm.c
@@ -959,10 +959,9 @@ enum ksm_get_folio_flags {
  * seconds or even minutes: much too unresponsive.  So instead we use a
  * "keyhole reference": access to the ksm page from the stable node peeps
  * out through its keyhole to see if that page still holds the right key,
- * pointing back to this stable node.  This relies on freeing a PageAnon
- * page to reset its page->mapping to NULL, and relies on no other use of
- * a page to put something that might look like our key in page->mapping.
- * is on its way to being freed; but it is an anomaly to bear in mind.
+ * pointing back to this stable node.  This relies on freeing an anon
+ * folio to reset its mapping to NULL, and relies on no other use of a
+ * folio to put something that might look like our key in its mapping.
  */
 static struct folio *ksm_get_folio(struct ksm_stable_node *stable_node,
 				 enum ksm_get_folio_flags flags)
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

selftests-mm-factor-out-hmm_buffer_alloc-to-consolidate-buffer-setup.patch
selftests-mm-fix-bug_on-checking-wrong-variable-in-mremap_dontunmap.patch
mm-swap-fix-swap_cluster_lock-config_swap-stub-signature-mismatch.patch
ksm-update-comments-and-docs-to-reference-folio-mapping.patch
mm-use-a-folio-in-the-softleaf_is_device_private-path.patch
selftests-prctl-fix-non-anonymous-vma-mapping-in-set-anon-vma-name-test.patch

