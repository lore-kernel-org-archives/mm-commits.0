Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07541FBF3
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 01:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708394219; cv=none; b=ap+8FwXOWakKFyWAr0w9uvocSsmsW8rruarii6kM8m/FW7soyiefF/h+uR4linRNPKGS6Cc/woWUzhfVTuHCZl4lT9YZlmXff4IXOPhXo6ktB0njLdzxqbRs9Xtv2xfi6REpOTRn8L3upXNYzh0CcfNzrEw98L8tHYMjAxou7c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708394219; c=relaxed/simple;
	bh=yQgqQMs3yqZ1L0S61qEHnGPTO8xJ4T4oURfZJkh47hw=;
	h=Date:To:From:Subject:Message-Id; b=lp5YXdSUdCLXF+XNMLBMuHfnZ8ubgq3sSgp7OL78YpI607X+pWaghm9ElGvdP+SPsL/BkAmFSoOLTSiixR9LO0O2XGCgnwPtqffaD0SXMSqK2SdnE0XZUPNdGEByi1tkjyXzHnTxhS733UUTRm3MLIHIxcYQKHRf40gMLDV4UCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gRgt2jtX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gRgt2jtX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A72CC433C7;
	Tue, 20 Feb 2024 01:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708394218;
	bh=yQgqQMs3yqZ1L0S61qEHnGPTO8xJ4T4oURfZJkh47hw=;
	h=Date:To:From:Subject:From;
	b=gRgt2jtXKv990OmAeDcfYYQn/hndDQc+Nj32/Lydj91uFAaLgb59nKA4KeOEYgJ8U
	 wpkFV9bIV0WQ+IOtz7RKkT5LjpljzNbTbpzCZJqOB5dn2L3u+r4d0wH3w9bNB9OFTM
	 xmmq4zzq+50cDAMFkFdrGxsso/Xi0dqbZvJ/0DNQ=
Date: Mon, 19 Feb 2024 17:56:57 -0800
To: mm-commits@vger.kernel.org,vitaly.wool@konsulko.com,linmiaohe@huawei.com,hannes@cmpxchg.org,hezhongkun.hzk@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-z3fold-fix-the-comment-for-__encode_handle.patch added to mm-unstable branch
Message-Id: <20240220015658.8A72CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/z3fold: fix the comment for __encode_handle()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-z3fold-fix-the-comment-for-__encode_handle.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-z3fold-fix-the-comment-for-__encode_handle.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Zhongkun He <hezhongkun.hzk@bytedance.com>
Subject: mm/z3fold: fix the comment for __encode_handle()
Date: Mon, 19 Feb 2024 10:44:53 +0800

The comment is confusing that Pool lock should be held as this function
accesses first_num above the __encode_handle() because first_num is the
element of z3fold_header which is protected by z3fold_header->page_lock.

I found the same comment for encode_handle() in zbud.c by accident ,Pool
lock should be held as this function accesses first|last_chunks, which is
the element of zbud_header and it does not have any lock, so pool lock
should be held.

Z3fold is based on zbud, maybe the comment come from zbud, but it was
wrong, so fix it.

Link: https://lkml.kernel.org/r/20240219024453.2240147-1-hezhongkun.hzk@bytedance.com
Signed-off-by: Zhongkun He <hezhongkun.hzk@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-fix-the-comment-for-__encode_handle
+++ a/mm/z3fold.c
@@ -364,8 +364,9 @@ static inline int __idx(struct z3fold_he
 }
 
 /*
- * Encodes the handle of a particular buddy within a z3fold page
- * Pool lock should be held as this function accesses first_num
+ * Encodes the handle of a particular buddy within a z3fold page.
+ * Zhdr->page_lock should be held as this function accesses first_num
+ * if bud != HEADLESS.
  */
 static unsigned long __encode_handle(struct z3fold_header *zhdr,
 				struct z3fold_buddy_slots *slots,
_

Patches currently in -mm which might be from hezhongkun.hzk@bytedance.com are

mm-z3fold-remove-unneeded-spinlock-in-z3fold_alloc.patch
mm-z3fold-remove-unneeded-spinlock.patch
mm-z3fold-fix-the-comment-for-__encode_handle.patch

