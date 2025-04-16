Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A676D21CC61
	for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 08:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744792120; cv=none; b=ZGptdTQzBjPCZS0SXtmbxNOX/bpgxVADKoz9nyT7JEzX+36vHyCon7GtLaE7a8+xEKE4JQOS7v1cK/YPY2ojpe5muWZw18DBBnE9Z/o/+xFlMlWOFnePbEEQsCnxh1jlQkt1DoZnOV92bpAzOSUlXW2WggkozuKvE2fxOAeehrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744792120; c=relaxed/simple;
	bh=P/l/AdS84246bZcdTTfQr8pOtXZ5omfvQ2SeX9M9aOA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gQUzz+z/JALSoL1ZfIdM67r3joj8HyYJF2NIYiZUhH0+ssyLUekS4wuOzOOJqSpkjCnmH/Xz+B3V1qWGO3zfj61dINWlB06OMm+npCjwnNn0B8F9WrHtDU/PX49kkXkBsep+xOF5rOPBtMLBTxUBsJNDnuvTz3esNQq+Hxx+MKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=brHZD2Va; arc=none smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="brHZD2Va"
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-86718c2c3b9so2346859241.2
        for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 01:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744792117; x=1745396917; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JIVppQrP+I4Rbmsp619tbAiG5Z/8Lai+OgK0i7/0LIQ=;
        b=brHZD2Va0s/SdSmcw4oTQ13BxHpWrthRdTuRmvNZfBHYYZStqJs4yqsC1Gj/akCq3y
         8ZiBxPxB+23nxoA0rkAK5hTiBgw++pXfW6ZCRHflSyY93WvA7ifhzSYTQo43qIZsbuxA
         +9ycUcEbozEjni4UAT8GU3mGlz/CipXnVuNE9gBG07a8HCkFvmXrXnzEaydOaVoprbES
         3pZTvRja/nzjdlHusAusA3vcd86ukXsrF6VvdJGGBXZ24A7Fz1QKgce/BduXWHaH1EhG
         UXXRo1HA7m7Z+Tsyo35KBLqlx5Fz6tmeHXRuU1gFwbYiCW8Fa8xf4j9eZmvYWt6f25DQ
         aZPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744792117; x=1745396917;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JIVppQrP+I4Rbmsp619tbAiG5Z/8Lai+OgK0i7/0LIQ=;
        b=bCUbFXZ+nF36dN9kmDSoccoMfLjRFLyo4fm2QZiW0wX3wRLwzHqmMjm9vwnwFmfScb
         3Spy2Pc6neXdVF5hTMIUqBdnOQhOYPN9kg19PBsyiuHHLmGi/EHdeST9yzCbs7/I1RSs
         qg8sxfktnU2KTw6O+DgnPKDf84cH7L5HObUaw9JLDr37wficWeAM0M3gdh4uUMmFR4cp
         IxBp8UcMMwNmFONvFf0Hmqo37gYmXUuexpkhcqkHkBJ1ln/fnMS47bOIzXazfnCVjypw
         evMnirKXfjaCfLiGMO4NTVLxx5s0rOtux1wU/oTDEoAimos/myRwvdod/UBNIeNCLQUT
         ZNvw==
X-Gm-Message-State: AOJu0Yyq3dVJj2aVMBL6qf8UJh0BSA/sjijtqxp1R+8mV+bBt6nGLjH0
	j1Jv69lkWB2aefrR+G+WPQuth7MrJwEEeY4UALzv98bZzJGP9bLurQ8Mlr1P5Jq1I34YvfY7K7C
	dN/pz9HYzWo1+ReJV9hwzY/YGNPQ=
X-Gm-Gg: ASbGnct8GF5O/iqYcGHIbDsVaVAHArQ0+RBI3nHOeBfjB8V6SZhWDMjtplX+7d63ghs
	HSaj6jJinCn46FN44kwncZ1ZWPUPBqs6ddIzJFKhQ2DPIt+rpN7OXXQYvbre4yOivUKMsCvj5O5
	qHs9NPVNIqdk4hU3G2hC1mXg==
X-Google-Smtp-Source: AGHT+IEUn6WTvlloYfwVmDkaMPoKJ40GFMiwX/sFyBmB3YR0KnE6PlGypJGlvJzj+bXef6/QnntPB9lPndroNyW2iP0=
X-Received: by 2002:a05:6102:3184:b0:4c3:6215:9f86 with SMTP id
 ada2fe7eead31-4cb592f042cmr247217137.19.1744792117159; Wed, 16 Apr 2025
 01:28:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250416021106.18BC6C4CEE7@smtp.kernel.org>
In-Reply-To: <20250416021106.18BC6C4CEE7@smtp.kernel.org>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 16 Apr 2025 16:28:26 +0800
X-Gm-Features: ATxdqUGHOgopwcFp2M4oN8DKJsaMg8_8wN14GFTBVNzBMyYaGLzI0qIJck5cLTk
Message-ID: <CAGsJ_4wQMby-i94p5WD1xNLBZpeVjpA9WCYm3gWFf=o-EwjStA@mail.gmail.com>
Subject: Re: + mm-contpte-optimize-loop-to-reduce-redundant-operations.patch
 added to mm-new branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org, 
	will@kernel.org, ryan.roberts@arm.com, Markus.Elfring@web.de, 
	ioworker0@gmail.com, gshan@redhat.com, dev.jain@arm.com, david@redhat.com, 
	catalin.marinas@arm.com, xavier_qy@163.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 16, 2025 at 10:11=E2=80=AFAM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: mm/contpte: optimize loop to reduce redundant operations
> has been added to the -mm mm-new branch.  Its filename is
>      mm-contpte-optimize-loop-to-reduce-redundant-operations.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/mm-contpte-optimize-loop-to-reduce-redundant-operations.patch
>
> This patch will later appear in the mm-new branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: Xavier <xavier_qy@163.com>
> Subject: mm/contpte: optimize loop to reduce redundant operations
> Date: Tue, 15 Apr 2025 16:22:05 +0800
>
> Optimize contpte_ptep_get() by adding early termination logic.  Check if
> the dirty and young bits of orig_pte are already set and skip redundant
> bit-setting operations during the loop.  This reduces unnecessary
> iterations and improves performance.
>
> The function's execution time and instruction statistics have been traced
> using perf, and the following are the operation results on a certain
> Qualcomm mobile phone chip:
>
> Instruction Statistics - Before Optimization
> #          count  event_name              # count / runtime
>       20,814,352  branch-load-misses      # 662.244 K/sec
>   41,894,986,323  branch-loads            # 1.333 G/sec
>        1,957,415  iTLB-load-misses        # 62.278 K/sec
>   49,872,282,100  iTLB-loads              # 1.587 G/sec
>      302,808,096  L1-icache-load-misses   # 9.634 M/sec
>   49,872,282,100  L1-icache-loads         # 1.587 G/sec
>
> Total test time: 31.485237 seconds.
>
> Instruction Statistics - After Optimization
> #          count  event_name              # count / runtime
>       19,340,524  branch-load-misses      # 688.753 K/sec
>   38,510,185,183  branch-loads            # 1.371 G/sec
>        1,812,716  iTLB-load-misses        # 64.554 K/sec
>   47,673,923,151  iTLB-loads              # 1.698 G/sec
>      675,853,661  L1-icache-load-misses   # 24.068 M/sec
>   47,673,923,151  L1-icache-loads         # 1.698 G/sec
>
> Total test time: 28.108048 seconds.
>
> Function Statistics - Before Optimization
> Arch: arm64
> Event: cpu-cycles (type 0, config 0)
> Samples: 1419716
> Event count: 99618088900
>
> Overhead   Symbol
> 21.42%     lock_release
> 21.26%     lock_acquire
> 20.88%     arch_counter_get_cntvct
> 14.32%     _raw_spin_unlock_irq
> 6.79%      contpte_ptep_get
> 2.20%      test_contpte_perf
> 1.82%      follow_page_pte
> 0.97%      lock_acquired
> 0.97%      rcu_is_watching
> 0.89%      mlock_pte_range
> 0.84%      sched_clock_noinstr
> 0.70%      handle_softirqs.llvm.8218488130471452153
> 0.58%      test_preempt_disable_long
> 0.57%      _raw_spin_unlock_irqrestore
> 0.54%      arch_stack_walk
> 0.51%      vm_normal_folio
> 0.48%      check_preemption_disabled
> 0.47%      stackinfo_get_task
> 0.36%      try_grab_folio
> 0.34%      preempt_count
> 0.32%      trace_preempt_on
> 0.29%      trace_preempt_off
> 0.24%      debug_smp_processor_id
>
> Function Statistics - After Optimization
> Arch: arm64
> Event: cpu-cycles (type 0, config 0)
> Samples: 1431006
> Event count: 118856425042
>
> Overhead   Symbol
> 22.59%     lock_release
> 22.13%     arch_counter_get_cntvct
> 22.08%     lock_acquire
> 15.32%     _raw_spin_unlock_irq
> 2.26%      test_contpte_perf
> 1.50%      follow_page_pte
> 1.49%      arch_stack_walk
> 1.30%      rcu_is_watching
> 1.09%      lock_acquired
> 1.07%      sched_clock_noinstr
> 0.88%      handle_softirqs.llvm.12507768597002095717
> 0.88%      trace_preempt_off
> 0.76%      _raw_spin_unlock_irqrestore
> 0.61%      check_preemption_disabled
> 0.52%      trace_preempt_on
> 0.50%      mlock_pte_range
> 0.43%      try_grab_folio
> 0.41%      folio_mark_accessed
> 0.40%      vm_normal_folio
> 0.38%      test_preempt_disable_long
> 0.28%      contpte_ptep_get
> 0.27%      __traceiter_android_rvh_preempt_disable
> 0.26%      debug_smp_processor_id
> 0.24%      return_address
> 0.20%      __pte_offset_map_lock
> 0.19%      unwind_next_frame_record
>
> If there is no problem with my test program, it can be seen that there is=
 a
> significant performance improvement both in the overall number of instruc=
tions
> and the execution time of contpte_ptep_get.
>
> If any reviewers have time, you can also test it on your machines for com=
parison.
> I have enabled THP and hugepages-64kB.
>
> Test function:
>
> #define PAGE_SIZE 4096
> #define CONT_PTES 16
> #define TEST_SIZE (4096* CONT_PTES * PAGE_SIZE)
>
> void rwdata(char *buf)
> {
>         for (size_t i =3D 0; i < TEST_SIZE; i +=3D PAGE_SIZE) {
>                 buf[i] =3D 'a';
>                 volatile char c =3D buf[i];
>         }
> }
> void test_contpte_perf()
> {
>         char *buf;
>         int ret =3D posix_memalign((void **)&buf, PAGE_SIZE, TEST_SIZE);
>         if (ret !=3D 0) {
>                 perror("posix_memalign failed");
>                 exit(EXIT_FAILURE);
>         }
>
>         rwdata(buf);
>
>         for (int j =3D 0; j < 500; j++) {
>                 mlock(buf, TEST_SIZE);
>
>                 rwdata(buf);
>
>                 munlock(buf, TEST_SIZE);
>         }
>
>         free(buf);
> }

Hi Xavier,

The data looks good while the test case seems unreal -  all PTEs are young
and all are dirty. we are getting "break" during accessing the first PTE. b=
ut
a real workload could be:

1. none of PTEs are dirty or young; (for example, An android app is moved
to background and not occupying the screen)

2. only one young PTE somewhere and no dirty.

For those cases, are we increasing instructions instead?

>
> Link: https://lkml.kernel.org/r/20250415082205.2249918-2-xavier_qy@163.co=
m
> Signed-off-by: Xavier <xavier_qy@163.com>
> Cc: Barry Song <21cnbao@gmail.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Gavin Shan <gshan@redhat.com>
> Cc: Lance Yang <ioworker0@gmail.com>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Markus Elfring <Markus.Elfring@web.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  arch/arm64/mm/contpte.c |   20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
>
> --- a/arch/arm64/mm/contpte.c~mm-contpte-optimize-loop-to-reduce-redundan=
t-operations
> +++ a/arch/arm64/mm/contpte.c
> @@ -152,6 +152,16 @@ void __contpte_try_unfold(struct mm_stru
>  }
>  EXPORT_SYMBOL_GPL(__contpte_try_unfold);
>
> +/* Note: in order to improve efficiency, using this macro will modify th=
e
> + * passed-in parameters.*/
> +#define CHECK_CONTPTE_FLAG(start, ptep, orig_pte, flag) \
> +    for (; (start) < CONT_PTES; (start)++, (ptep)++) { \
> +               if (pte_##flag(__ptep_get(ptep))) { \
> +                               orig_pte =3D pte_mk##flag(orig_pte); \
> +                               break; \
> +               } \
> +    }
> +
>  pte_t contpte_ptep_get(pte_t *ptep, pte_t orig_pte)
>  {
>         /*
> @@ -169,11 +179,17 @@ pte_t contpte_ptep_get(pte_t *ptep, pte_
>         for (i =3D 0; i < CONT_PTES; i++, ptep++) {
>                 pte =3D __ptep_get(ptep);
>
> -               if (pte_dirty(pte))
> +               if (pte_dirty(pte)) {
>                         orig_pte =3D pte_mkdirty(orig_pte);
> +                       CHECK_CONTPTE_FLAG(i, ptep, orig_pte, young);
> +                       break;
> +               }
>
> -               if (pte_young(pte))
> +               if (pte_young(pte)) {
>                         orig_pte =3D pte_mkyoung(orig_pte);
> +                       CHECK_CONTPTE_FLAG(i, ptep, orig_pte, dirty);
> +                       break;
> +               }
>         }
>
>         return orig_pte;
> _
>
> Patches currently in -mm which might be from xavier_qy@163.com are
>
> mm-contpte-optimize-loop-to-reduce-redundant-operations.patch
>

Thanks
Barry
