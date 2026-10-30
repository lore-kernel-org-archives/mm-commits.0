Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793329350;
	b=4GEuoMIfTmJIt1uOJj/nkf+TTWSRu4Z/emjhynePqTclJhyMXhRA3DCzQfohiMsjAGK7
	 tgfRUA4mtFCjbXglU+ubm6zMdFBoD7Fr3ZuXTRHsXIbQqaCYLF8ZYvDqT0LAIVDtAiWJx
	 2T/xJ/9NXckmnMM0sljCjXks6WmRhzgwhdGholq1Kb+h9muwmckv4XMzN6B72cKCgPkS9
	 DLqMUahbuQNsmxnOz75lwPH1NPvx89rSLkvp3QQ78wxXr4u1T7r8HE8PWh5hit6nS1Dp2
	 aZWgA1dLUfp+rM2Cik05bOCY3qB1OjuArI48ga8MRJlfcdfrBzu84+QhdMFRC72xQtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793329350;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=QUlxEwyRkGzFYkxGcMWcFTU0NG5XRtmeXLT8AY+6eLs=;
	b=w3U2qIzeQKYtkxuLTzFmjZzJzaZkRpaMkCl8lkN5xv22xQjq5fNXE4HcazCsnuESCmb4
	 6cq61t/XONrqJYevvCpM0OzzyB99dCRmaNnC7/GPQpzPDsMq05NF7E64OObo66qC3IGkI
	 q8P5ZNChjPYPXZ6Qvw65gXL3YjbKyesWbB0lgU1R6+rekuhNmM4u5RZQbr298ZnfMaDh/
	 jR3deL72shs4jKnjckYtuIpBJfyxtnGbOhVbQTXlZ+53rTE/ZrNwxOkGcL+miQgpmRaoC
	 D6A/97fjGHLk3vR8eKR07h1dj3afVoqAOTRJbAQITjPf0VZu9eXsOnhp4aUPTUuR5Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QoQz8NdK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD848606A325
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 03:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QoQz8NdK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A85B1F000C1;
	Fri, 30 Oct 2026 03:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793329349;
	bh=QUlxEwyRkGzFYkxGcMWcFTU0NG5XRtmeXLT8AY+6eLs=;
	h=Date:To:From:Subject;
	b=QoQz8NdKzgfVIKlxZrOxJ8G5jiCD4mrcg25rcHplyzTngqMuR1C+TfEBW5aDJv2SV
	 hn1gNtr84tDXCKjkFlDPae5FF7SVvHhNgedrqUeqmO6lmOqQt4vHWTv1e0FRXqy4b6
	 IW0yRffwjb5Vm8c+vizLE7Kz1zNUtIeZh7io1xHg=
Date: Thu, 29 Oct 2026 20:02:29 -0700
To: mm-commits@vger.kernel.org,zhangbo56@xiaomi.com,zhangbo0325@gmail.com,
	richardycc@google.com,minchan@kernel.org,hdanton@sina.com,bgeffon@google.com,
	baohua@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-zstd-do-not-allocate-empty-c-d-dictionaries.patch added to mm-nonmm-unstable branch
Message-Id: <20261030030229.9A85B1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: zram: zstd: do not allocate empty C/D-dictionaries
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     zram-zstd-do-not-allocate-empty-c-d-dictionaries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-zstd-do-not-allocate-empty-c-d-dictionaries.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: zstd: do not allocate empty C/D-dictionaries
Date: Sun, 25 Oct 2026 11:18:22 +0900

Do not zstd_create_cdict_byreference() / zstd_create_ddict_byreference()
C/D dictionaries when no dictionary was provided in the first place,
because zstd still allocates internal memory for such calls (~96 KB at
default level 3, and ~160 KB at levels 9+ on x86_64).

Link: https://lore.kernel.org/20261025021839.1542805-7-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Bo Zhang <zhangbo0325@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Cc: Bo Zhang <zhangbo56@xiaomi.com>
Cc: Hillf Danton <hdanton@sina.com>
---

 drivers/block/zram/backend_zstd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/block/zram/backend_zstd.c~zram-zstd-do-not-allocate-empty-c-d-dictionaries
+++ a/drivers/block/zram/backend_zstd.c
@@ -76,6 +76,9 @@ static int zstd_setup_params(struct zcom
 	prm = zstd_get_cparams(params->level, PAGE_SIZE,
 			       params->dict_sz);
 
+	if (!params->dict || !params->dict_sz)
+		return 0;
+
 	zp->cdict = zstd_create_cdict_byreference(params->dict,
 						  params->dict_sz,
 						  prm,
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-prefix-backends-printk-s.patch
zram-remove-debugfs-entry-on-init-failure.patch
zram-reset-writeback-state-in-zram_reset_device.patch
zram-move-mark_slot_accessed-under-existing-slot-lock-sections.patch
zram-remove-stale-warn_on-from-zram_read_page.patch
zram-zstd-do-not-allocate-empty-c-d-dictionaries.patch
zram-lz4hc-pre-initialize-dictionary-stream-in-setup_params.patch
zram-lz4-use-lz4_decompress_safe_usingdict.patch
zram-lz4hc-use-lz4_decompress_safe_usingdict.patch
zram-zstd-do-not-use-kvzalloc-for-zstd-allocations.patch
zram-split-zcomp-into-separate-r-w-streams.patch
zram-introduce-shared-decompression-streams.patch
zram-allocate-bounce-buffer-for-spanning-objects.patch
zram-borrow-idle-decompression-streams-in-exclusive-mode.patch
zram-use-a-singleton-compression-context-for-recompression.patch

