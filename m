Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 067D0C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 06:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237058AbiEJGfi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 02:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbiEJGfg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 02:35:36 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CAF20CA71
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 23:31:38 -0700 (PDT)
Date:   Tue, 10 May 2022 08:31:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1652164296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rwg152YQwuidsQvHxPi2XfPFRUsWUU4YTv1YxKk9N7o=;
        b=qDDrM0kN8zdrCrsmfbDblkQ3HwEbpBLPH8+BGbMhAH7UuLnFD4yc9EqyxtXxYkK3Uxuo39
        zpR337kNgqV4rTaIbhZ1siawUZ7Ya/5Bl3I29SLUzKNTymDzQDSol8lKoN6wzhzBjXaDMy
        UHFOr7VKq6i9a/Yn2xQJySYaxAnS8I8ulnN+mWznYhwVT9LqRYZMKj1E8S6iG8KcGLS0Vp
        IUmoOvLzIGJbhs5ZTD3XFiiSI+qatyigR4D6B2JsAsIdGQJ6cUxAmFCGglmWGInG1PqNTc
        fR+6A1lbI1cEMiyCnv93qgHV9ofnl1d0wLW0kY+t5SRyjf/lHIl7ST22vWsPnw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1652164296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rwg152YQwuidsQvHxPi2XfPFRUsWUU4YTv1YxKk9N7o=;
        b=mUXb/7vvY0B2a14il65/v2nt6LnHnZOZ9VrD6xmqnmpXLe3twYD9tdA2kB5bWOV90sB2rk
        9GpFZRl+gRvkMQCQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, dvyukov@google.com, andreyknvl@gmail.com,
        qiang1.zhang@intel.com, tglx@linutronix.de
Subject: Re: [merged mm-stable]
 kasan-fix-sleeping-function-called-from-invalid-context-on-rt-kernel.patch
 removed from -mm tree
Message-ID: <YnoGxhug+c2v2GSZ@linutronix.de>
References: <20220510041417.A3E81C385C2@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220510041417.A3E81C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 2022-05-09 21:14:17 [-0700], Andrew Morton wrote:
> BUG: sleeping function called from invalid context at kernel/locking/spin=
lock_rt.c:46
> in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 1, name: swapper/0
> preempt_count: 1, expected: 0
> ...........
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.17.1-rt16-yocto-preempt-rt #22
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
> BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
> Call Trace:
> <TASK>
> dump_stack_lvl+0x60/0x8c
> dump_stack+0x10/0x12
>  __might_resched.cold+0x13b/0x173
> rt_spin_lock+0x5b/0xf0
>  ___cache_free+0xa5/0x180
> qlist_free_all+0x7a/0x160
> per_cpu_remove_cache+0x5f/0x70
> smp_call_function_many_cond+0x4c4/0x4f0
> on_each_cpu_cond_mask+0x49/0xc0
> kasan_quarantine_remove_cache+0x54/0xf0
=E2=80=A6
>=20
> When the kmem_cache_shrink() was called, the IPI was triggered, the
> ___cache_free() is called in IPI interrupt context, the local-lock or
> spin-lock will be acquired.  On PREEMPT_RT kernel, these locks are
> replaced with sleepbale rt-spinlock, so the above problem is triggered.=
=20
> Fix it by moving the qlist_free_allfrom() from IPI interrupt context to
> task context when PREEMPT_RT is enabled.

I would prefer something without that ifdef RT. That might still trigger
lockdep with CONFIG_PROVE_RAW_LOCK_NESTING since you are in IRQ-off
context (IPI) and your ___cache_free() may acquire a spinlock_t.

Is it impossible/ impracticable to always access the list cross-CPU
(with a lock instead of this_cpu access + IRQ-off)? Or always do what
this patch suggest for RT?

> [akpm@linux-foundation.org: reduce ifdeffery]
> Link: https://lkml.kernel.org/r/20220401134649.2222485-1-qiang1.zhang@int=
el.com
> Signed-off-by: Zqiang <qiang1.zhang@intel.com>
> Acked-by: Dmitry Vyukov <dvyukov@google.com>
> Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Andrey Konovalov <andreyknvl@gmail.com>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Sebastian
