Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED0A27E049
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779138202; cv=none; b=Afz1beFp2ktMHLiynPGX3R2GPaE2eqND/o56DMiXPIRS8N7y7l9f1UU5Hgb212cr/KE589q5cIjUCXIGjfxSIz2P+jf6H/+o5DkhH8UZoTcK9hAZFje7RLFfZSEeTD3JbhrDKEqy/069e4yAVvEl5Ewjyi2aFQX7Aj7u3TlEnZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779138202; c=relaxed/simple;
	bh=mKAFA5P20aTWxrYxyfhW2XS6lUqhYbP8ofc+ooGW7n8=;
	h=Date:To:From:Subject:Message-Id; b=uIhqGZl0/k0sKftQ+Uf1LITsH2B5w9EiSmfMvyI9vOb803tjuCnGj0ygHKvBxKv+m8diYbl9pG+OlBq0YIVyDnQjdpb3oqlh2lR0FB8mhdbXe1+XFmERm5LYWb1eMVhKuIwHKVaKmAZu63oAhSI/7hFmvgLze5fqurd/F88jDfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RyzIdiQ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RyzIdiQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F22C2BCC6;
	Mon, 18 May 2026 21:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779138201;
	bh=mKAFA5P20aTWxrYxyfhW2XS6lUqhYbP8ofc+ooGW7n8=;
	h=Date:To:From:Subject:From;
	b=RyzIdiQ/HfmsYToyv992VEJT9I+9mm++xW+xA+3PdOj7ty0pfp7/EVfDOXZlUmeOr
	 ORjmrB9fSFLGiePhXUAJu/ouyP6cKzoFlCTdpvMtXdZ62W2y+X624tBtkbfuRAGt2v
	 dG0D2NCeg03WAceuH+9l+9CJmgThKbG8PIZr6MsI=
Date: Mon, 18 May 2026 14:03:21 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sj@kernel.org,akpm@linux-foundation.org,wangxuewen@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-slabinfo-remove-redundant-slab-partial-assignment.patch added to mm-new branch
Message-Id: <20260518210321.99F22C2BCC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm/slabinfo: remove redundant slab->partial assignment
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-slabinfo-remove-redundant-slab-partial-assignment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-slabinfo-remove-redundant-slab-partial-assignment.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Xuewen Wang <wangxuewen@kylinos.cn>
Subject: tools/mm/slabinfo: remove redundant slab->partial assignment
Date: Mon, 18 May 2026 14:21:59 +0800

slab->partial is assigned by get_obj("partial") and then immediately
overwritten by get_obj_and_str("partial", &t).  Remove the first redundant
assignment.

Link: https://lore.kernel.org/20260518062159.80664-4-wangxuewen@kylinos.cn
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/slabinfo.c |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/mm/slabinfo.c~tools-mm-slabinfo-remove-redundant-slab-partial-assignment
+++ a/tools/mm/slabinfo.c
@@ -1265,7 +1265,6 @@ static void read_slab_dir(void)
 			slab->objects_total = get_obj("objects_total");
 			slab->objs_per_slab = get_obj("objs_per_slab");
 			slab->order = get_obj("order");
-			slab->partial = get_obj("partial");
 			slab->partial = get_obj_and_str("partial", &t);
 			decode_numa_list(slab->numa_partial, t);
 			free(t);
_

Patches currently in -mm which might be from wangxuewen@kylinos.cn are

mm-memory-failure-replace-magic-number-3-with-get_page_max_retry_num.patch
tools-mm-slabinfo-fix-trace-disable-logic-inversion.patch
tools-mm-slabinfo-remove-dead-assignment-in-get_obj_and_str.patch
tools-mm-slabinfo-remove-redundant-slab-partial-assignment.patch

