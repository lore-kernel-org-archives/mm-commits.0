Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5F93793DE
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966490; cv=none; b=j9NO426HKj0veXZiveYiHPX1m8+Oa8mrq57hCFXPf6Ec6wfGxokOiVcEGfQuIKv/JiymD2r5m1FYkm4IX9u8ueCJsCwuUjjUyo1F8DGgG8Ums3wBr80qRrEHa73e6F0Jmy1Q+oiPLqN1Ct4kbkVkGEIzx4xsYvjpAGP7lsEAyxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966490; c=relaxed/simple;
	bh=ScEalZyjv8zDetdJD9xJjMeipA7Ul+WIoQns9eOmf7Q=;
	h=Date:To:From:Subject:Message-Id; b=dvanSNFtix5bbh6zN/jI5cMjD9Pnjl0EaY/p8yJEYLTyK+foMzsyiRXl8ZFiGB8fj4fETLSSKbkfHVDm5HN4rwdx20ChYwBcNimkl2q6/gaiAsDtBVYP2eOox2csqRrAgCQ/j4blH5uHc4leFYj81J1LVoMZwLL/MweHNUZwH+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j/xp/QZM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j/xp/QZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CE8C19423;
	Wed, 21 Jan 2026 03:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966490;
	bh=ScEalZyjv8zDetdJD9xJjMeipA7Ul+WIoQns9eOmf7Q=;
	h=Date:To:From:Subject:From;
	b=j/xp/QZMsPdOnX0OMxoNtELStiOX7mA8tEdk9kxGghxHDzPuSFnC5k+HzqkIteIox
	 hJ/9P+qXb3GVoIfHQaMQY56k0Kxe06t6RziM+evcuYQiMA6dC8jciobaGMkPh9PYtI
	 Xd0pGtkV5nC+MEqoDrUxpv+XMLte+WAhekLcr3nA=
Date: Tue, 20 Jan 2026 19:34:50 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,lkp@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix.patch removed from -mm tree
Message-Id: <20260121033450.A5CE8C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix
has been removed from the -mm tree.  Its filename was
     kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix.patch

This patch was dropped because it was folded into kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix
Date: Tue Jan 13 09:46:56 AM PST 2026

fix loongarch

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601140159.I4b0kwpE-lkp@intel.com/
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/net/bpf_jit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/net/bpf_jit.c~kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix
+++ a/arch/loongarch/net/bpf_jit.c
@@ -1319,7 +1319,7 @@ int bpf_arch_text_poke(void *ip, enum bp
 	/* Only poking bpf text is supported. Since kernel function entry
 	 * is set up by ftrace, we rely on ftrace to poke kernel functions.
 	 */
-	if (!__bpf_address_lookup((unsigned long)ip, &size, &offset, namebuf))
+	if (!bpf_address_lookup((unsigned long)ip, &size, &offset, namebuf))
 		return -ENOTSUPP;
 
 	image = ip - offset;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix.patch
mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch
kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup.patch
list-add-primitives-for-private-list-manipulations-fix.patch
init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix.patch

