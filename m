Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.62
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795717814;
	b=k4XOPzM6MWpJ+xP4njRz35h+epOxk8VXObjpiACwsgZDsCP+b11CIY5WbqwaIvfqikFu
	 5IlpFzcIfFcDgdARjxCn22OHqtyZXdbvoDYTtd6drnQ7yeviQzz50lxjktc047W2s52T3
	 Ea1hYy1Xh1AZYiFsmamnkKz8tas05J7MKwzqN6U1uaievWq1Sut+zb+ppXWihEwmAGnrT
	 H6x3ggkb9JbC5Cv4BONGQzoRaZDP5aeIr897IXW+yR2WFOopRDury9HbvUr7D/KLTi73d
	 mp93uF1P/K2JRWu0xBIT8Ic4v4HLIWyRR2N3m5UpGfD6va9vJPvSISo+2EpwXKCzmkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795717814;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:CC:Subject:In-Reply-To:
	 Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=vyNTGZ09bSYkWk9JGBGFeO0eJS9bmeFv+8W4gSlayZc=;
	b=zcIglWi6r5gM68rz1jNeb7W+t1vrlGywCn7EuxgBEK8d512G9EgfBiiNBLZb5jOE8Qhs
	 gsj2KsmwO8RFCeMOJhXNOQuk7YCv4VUGuR/NpTY6ridbge9iYjW41XfD8jhUet7rcjjLO
	 8FwCPJPvCyuz9xhtmAcYNGW35f1OIodFLEeHMxMW4v0Qkv2cOPWBUDbh7wo62nqX+T/Ha
	 5sIzcPfq5HHIi7Rwi61CdkqjJEYDf4jT+OvEitMybaGHg17QXNnTltYQ8+wXAra+qsXKE
	 Ri+YtlgYrR/lmKm6bOnN8q1FYzSHkOruDSorejo82lMCnNGH6Xh1yH/A1zdwqtHLacg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mHCvyWVH;
	arc=none smtp.remote-ip=91.218.175.62
Received: from mta0.migadu.com (out-62.mta0.migadu.com [91.218.175.62])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79FB606A323
	for <mm-commits@vger.kernel.org>; Thu, 26 Nov 2026 18:30:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E79FB606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mHCvyWVH
X-Envelope-To: mm-commits@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=dwYDrxKGv6RQjVS+q8TM4vzzdVOzNwSnt4+bsC0sipI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795717812; v=1; x=1796322612;
 b=mHCvyWVHLxd3vpT2w4bkhOanRNBOjX4B74nVCzbNzK4b28U3UzUVaUA2YLHI0zk2RZcGhe5U
 6o+meH+cd+SnFHWwl4LU4n9GJaqi2NtvrWlduY0HY0sqFEXFmcUDO1PyI8VTb1tD0wY6HCTYHI2
 XDjbj16DMcqBPKuq5h6LdWWU=
X-Envelope-To: mm-commits@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 584adf477b23d1d9;
	Thu, 26 Nov 2026 18:30:11 +0000
X-Mizu-Trace-ID: 584adf477b23d1d9
X-Migadu-Flow: FLOW_OUT
Date: Thu, 26 Nov 2026 18:30:07 +0000
From: Bradley Morgan <bradley.morgan@linux.dev>
To: akpm@linux-foundation.org
CC: andreyknvl@gmail.com, chenxionggui@lanxincomputing.com, dvyukov@google.com,
 glider@google.com, mm-commits@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_+_kcov-defer-pc-canonicalization-until-tracing?=
 =?US-ASCII?Q?-is-enabled=2Epatch_added_to_mm-nonmm-unstable_branch?=
In-Reply-To: <20261126064649.84E601F000CA@smtp.kernel.org>
Message-ID: <A0391DC0-0496-4564-8CBD-0E9009386193@linux.dev>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On 26 November 2026 06:46:48 GMT, Andrew Morton <akpm@linux-foundation.org>
wrote:
>
>The patch titled
>     Subject: kcov: defer PC canonicalization until tracing is enabled
>has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>     kcov-defer-pc-canonicalization-until-tracing-is-enabled.patch
>
>This patch will shortly appear at
>     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcov-defer-pc-canonicalization-until-tracing-is-enabled.patch
>
>This patch will later appear in the mm-nonmm-unstable branch at
>    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
>Before you just go and hit "reply", please:
>   a) Consider who else should be cc'ed
>   b) Prefer to cc a suitable mailing list as well
>   c) Ideally: find the original patch on the mailing list and do a
>      reply-to-all to that, adding suitable additional cc's
>
>*** Remember to use Documentation/process/submit-checklist.rst when
>testing your code ***
>
>The -mm tree is included into linux-next via various
>branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>and is updated there most days
>
>------------------------------------------------------
>From: Xionggui Chen <chenxionggui@lanxincomputing.com>
>Subject: kcov: defer PC canonicalization until tracing is enabled
>Date: Wed, 25 Nov 2026 03:36:35 +0000
>
>When CONFIG_KCOV_INSTRUMENT_ALL and CONFIG_RANDOMIZE_BASE are enabled,
>__sanitizer_cov_trace_pc() may be called during early boot before the
>kernel's virtual memory mappings are fully initialized.
>
>Currently, canonicalize_ip() is called before checking whether KCOV
>tracing is enabled.  On RISC-V, canonicalize_ip() calls kaslr_offset(),
>which accesses kernel mapping information that may not yet be accessible.
>
>This causes an early boot load access fault even when KCOV tracing is
>disabled.
>
>Move canonicalize_ip() after check_kcov_mode() to avoid accessing the
>KASLR offset when KCOV tracing is disabled.
>
>The comparison tracing path already performs this check before
>canonicalizing the instruction pointer.
>
>The issue was reproduced on RISC-V with Linux 7.4-rc1 using
>CONFIG_KCOV_INSTRUMENT_ALL=y and CONFIG_RANDOMIZE_BASE=y.
>
>The fix was verified on QEMU and RISC-V hardware.  KCOV PC tracing
>collected 124 entries, and comparison tracing collected 63 entries on the
>RISC-V hardware.
>
>Link: https://patch.msgid.link/20261125033635.3990-1-evers_chen@163.com
>Fixes: ded97d2c2b2c ("kcov: support comparison operands collection")
>Signed-off-by: Xionggui Chen <chenxionggui@lanxincomputing.com>
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>Cc: Andrey Konovalov <andreyknvl@gmail.com>
>Cc: Alexander Potapenko <glider@google.com>

Sorry, forgot to review on my roll.

Reviewed-by: Bradley Morgan <bradley.morgan@linux.dev>


>Cc: Dmitry Vyukov <dvyukov@google.com>
>
> kernel/kcov.c |    3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
>--- a/kernel/kcov.c~kcov-defer-pc-canonicalization-until-tracing-is-enabled
>+++ a/kernel/kcov.c
>@@ -216,13 +216,14 @@ void notrace __sanitizer_cov_trace_pc(vo
> {
> 	struct task_struct *t;
> 	unsigned long *area;
>-	unsigned long ip = canonicalize_ip(_RET_IP_);
>+	unsigned long ip;
> 	unsigned long pos;
> 
> 	t = current;
> 	if (!check_kcov_mode(KCOV_MODE_TRACE_PC, t))
> 		return;
> 
>+	ip = canonicalize_ip(_RET_IP_);
> 	area = t->kcov_area;
> 	/* The first 64-bit word is the number of subsequent PCs. */
> 	pos = READ_ONCE(area[0]) + 1;
>_
>
>Patches currently in -mm which might be from
>chenxionggui@lanxincomputing.com are
>
>selftests-mm-handle-implicit-read-permissions-in-madv_populate.patch
>kcov-defer-pc-canonicalization-until-tracing-is-enabled.patch
>
>
>

--- Thanks!
