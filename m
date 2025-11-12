Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997861373
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762906549; cv=none; b=V0/WDPZh0rB60hZRwXs6k4JOS7njfvMyDtn1+bhDq/KUhD+32y0mcnq9iFszgd3j7JBxpZruz+RU6DGfsp6JTwYFQrrzg7Hv5A1IB2vL2Z1MZ7ycVQ3lQg/PfyG0WhioOl5DixH2fdan6s/87j2+5w45mo/OlUaDTo16n5nGcRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762906549; c=relaxed/simple;
	bh=RPgMUPn0fb6btqi29tZVcGtFxr49zxZC9SHbs2bdgd0=;
	h=Date:To:From:Subject:Message-Id; b=LNhpd6GMJqiOFy2SC4GcjP8L+7/80F1h9qimSrqVBxZqsaX46WLUMbMHVROo3/oWrRDZMJIjmm1tnCtXkMoJhf/vDpsOE1YWMnGz217Vjc+vELay4+BA5FWLnzgPPamX7zEbu/9E9lkH5YfS9VPCYtemTypv3nSz7zcd26i+Bbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DPwvor8c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DPwvor8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29636C4CEF5;
	Wed, 12 Nov 2025 00:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762906549;
	bh=RPgMUPn0fb6btqi29tZVcGtFxr49zxZC9SHbs2bdgd0=;
	h=Date:To:From:Subject:From;
	b=DPwvor8cZ/FRgoXZSX7BSjOjjwDuFsPjX15DGTXMpvkZFAM8wAgJOR+a9ZIT4Y8kl
	 wW4bxyohvajqr+2sooAVsPT/IRFzk7xau0IFrNxpwCkgnpj+HaaB5kG9m6uMLdhdb/
	 h5t6R7NS7ibzZXqAU7xkKO+zuFwU+Jg99GZx/I10=
Date: Tue, 11 Nov 2025 16:15:48 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shmem-tmpfs-hugepage-defaults-config-choice-v2.patch removed from -mm tree
Message-Id: <20251112001549.29636C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-shmem-tmpfs-hugepage-defaults-config-choice-v2
has been removed from the -mm tree.  Its filename was
     mm-shmem-tmpfs-hugepage-defaults-config-choice-v2.patch

This patch was dropped because it was folded into mm-shmem-tmpfs-hugepage-defaults-config-choice.patch

------------------------------------------------------
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm-shmem-tmpfs-hugepage-defaults-config-choice-v2
Date: Tue, 28 Oct 2025 17:49:50 +0000

- Mentioned Kconfig options in Documentation/admin-guide/mm/transhuge.rst. 
  Didn't list all of them intentionally to avoid duplication and possible 
  content drift in the future.
- Expanded commit message with rationale behind the change. Mentioned Meta
  explicitly.

Link: https://lkml.kernel.org/r/aQECPpjd-fU_TC79@shell.ilvokhin.com
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-shmem-tmpfs-hugepage-defaults-config-choice-v2
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -381,6 +381,11 @@ hugepage allocation policy for the tmpfs
 four valid policies for tmpfs (``always``, ``within_size``, ``advise``,
 ``never``). The tmpfs mount default policy is ``never``.
 
+Additionally, Kconfig options are available to set the default hugepage
+policies for shmem (``CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_*``) and tmpfs
+(``CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_*``) at build time. Refer to the
+Kconfig help for more details.
+
 In the same manner as ``thp_anon`` controls each supported anonymous THP
 size, ``thp_shmem`` controls each supported shmem THP size. ``thp_shmem``
 has the same format as ``thp_anon``, but also supports the policy
_

Patches currently in -mm which might be from d@ilvokhin.com are

mm-shmem-tmpfs-hugepage-defaults-config-choice.patch

