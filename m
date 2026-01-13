Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9C634889A
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 17:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768326531; cv=none; b=nDGTL+oz0lAuIOFXtWL4h3ylt9f81gxa0sqHlvSWF+1tvIznAeTZUnpqFZMfbEzhhAHhVK1C1EF2rD89arDH7EDxp4DL1kDggeCmh3KY9meWpdm+9/V1mfn+KZh7D0yFyH1y6u8pLLWpk5aQW3PpI6SjQABlR/NnPSnS4jJmgNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768326531; c=relaxed/simple;
	bh=4DjXYeAz/hMQT4gqp4bV2vnM3FFj8+I9+yMTxB5oKkE=;
	h=Date:To:From:Subject:Message-Id; b=PeLKkzSbrnf5Y1y+yJv3ypszXs13jKTEKMKXcBwDe53i5QouTdC96ugK50KhAEGSEoRAXfyJTwsWckbKSAkgmU41kQo+vthcUyomlsumjivhsGNngqf9frHS3wGYTlfXkOgrWHxoUUAZgeZDwnUSVMGFBbjLgP7QWHad4GrwJPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zKvYU3o2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zKvYU3o2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B54C116C6;
	Tue, 13 Jan 2026 17:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768326530;
	bh=4DjXYeAz/hMQT4gqp4bV2vnM3FFj8+I9+yMTxB5oKkE=;
	h=Date:To:From:Subject:From;
	b=zKvYU3o25LswqU7q/SxDtpsVKVz7B55oMO6+n7EKDv8tJcdkqqyfooqJRQBpUcUe/
	 lYNalrhyzKCjIq6xA+UuTS43z9WclOW2PouHY80Au9G6JisqUkMX4AzwuU6o5Vs2aS
	 E0BEcCmo8WiVCX4QSRmyilwAX0YWFn8U2yFeE8ns=
Date: Tue, 13 Jan 2026 09:48:50 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,lkp@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260113174850.D2B54C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

mm-add-basic-tests-for-lazy_mmu-fix.patch
mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
mm-block-fs-remove-laptop_mode-fix.patch
mm-fix-minor-spelling-mistakes-in-comments-fix.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-memory-tiers-numa_emu-enable-to-create-memory-tiers-using-fake-numa-nodes-fix.patch
kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix.patch
list-add-primitives-for-private-list-manipulations-fix.patch
init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix.patch

