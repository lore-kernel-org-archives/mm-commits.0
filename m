Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CBCC2D0A3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 00:41:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A82A822404
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 00:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604450503;
	bh=+oXqgsNGEXAJU+4OaE1KrWgFvpSPmqIvV0MrOMBZLXo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=siypGexb6O/fZ9YEbl1ZCr0p934m3qlOTHoGiRO5sLIuVKnYEXRl13EJsoSrffs32
	 dprROVH5LVeYSdWLjBW2BgydNo5MQ96t4MpMta0Pq+9fD/lvshQXp6cdsnmALwPpKq
	 2Mxj4R1WPqqMwiuDMCiVZDWENkkrbowKVsBEqUVo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbgKDAln (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 19:41:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:51070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbgKDAln (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 19:41:43 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B7B8223EA;
        Wed,  4 Nov 2020 00:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604450502;
        bh=+oXqgsNGEXAJU+4OaE1KrWgFvpSPmqIvV0MrOMBZLXo=;
        h=Date:From:To:Subject:From;
        b=fjcwrGVJri8DqV2+9cINwg7AtGmmCUnkLPOJ8VKX7mChxZ4gnajpIhFxGRt5RrdMO
         SFD/MFEcvW40vF4Erdy7IlVzjj6NLBKVnglr5fgZQGe5nn1KVwhm+w9VAe3MAhfDob
         yPn6qXTdF1EPHAgFy3ymhbEqcSNzlWIi7+uGJOm0=
Date:   Tue, 03 Nov 2020 16:41:39 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, vbabka@suse.cz,
        tglx@linutronix.de, sjpark@amazon.de, rientjes@google.com,
        peterz@infradead.org, penberg@kernel.org, paulmck@kernel.org,
        mingo@redhat.com, mark.rutland@arm.com, luto@kernel.org,
        keescook@chromium.org, joern@purestorage.com, jannh@google.com,
        iamjoonsoo.kim@lge.com, hpa@zytor.com, hdanton@sina.com,
        gregkh@linuxfoundation.org, glider@google.com, edumazet@google.com,
        dvyukov@google.com, dave.hansen@linux.intel.com, corbet@lwn.net,
        cl@linux.com, catalin.marinas@arm.com, bp@alien8.de,
        aryabinin@virtuozzo.com, andreyknvl@google.com, elver@google.com
Subject:  + kfence-documentation-add-kfence-documentation.patch added
 to -mm tree
Message-ID: <20201104004139.jk6uM%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence, Documentation: add KFENCE documentation
has been added to the -mm tree.  Its filename is
     kfence-documentation-add-kfence-documentation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-documentation-add-kfence-documentation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-documentation-add-kfence-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence, Documentation: add KFENCE documentation

Add KFENCE documentation in dev-tools/kfence.rst, and add to index.

Link: https://lkml.kernel.org/r/20201103175841.3495947-8-elver@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Co-developed-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Jann Horn <jannh@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joern Engel <joern@purestorage.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: SeongJae Park <sjpark@amazon.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/index.rst  |    1 
 Documentation/dev-tools/kfence.rst |  297 +++++++++++++++++++++++++++
 lib/Kconfig.kfence                 |    2 
 3 files changed, 300 insertions(+)

--- a/Documentation/dev-tools/index.rst~kfence-documentation-add-kfence-documentation
+++ a/Documentation/dev-tools/index.rst
@@ -22,6 +22,7 @@ whole; patches welcome!
    ubsan
    kmemleak
    kcsan
+   kfence
    gdb-kernel-debugging
    kgdb
    kselftest
--- /dev/null
+++ a/Documentation/dev-tools/kfence.rst
@@ -0,0 +1,297 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Kernel Electric-Fence (KFENCE)
+==============================
+
+Kernel Electric-Fence (KFENCE) is a low-overhead sampling-based memory safety
+error detector. KFENCE detects heap out-of-bounds access, use-after-free, and
+invalid-free errors.
+
+KFENCE is designed to be enabled in production kernels, and has near zero
+performance overhead. Compared to KASAN, KFENCE trades performance for
+precision. The main motivation behind KFENCE's design, is that with enough
+total uptime KFENCE will detect bugs in code paths not typically exercised by
+non-production test workloads. One way to quickly achieve a large enough total
+uptime is when the tool is deployed across a large fleet of machines.
+
+Usage
+-----
+
+To enable KFENCE, configure the kernel with::
+
+    CONFIG_KFENCE=y
+
+To build a kernel with KFENCE support, but disabled by default (to enable, set
+``kfence.sample_interval`` to non-zero value), configure the kernel with::
+
+    CONFIG_KFENCE=y
+    CONFIG_KFENCE_SAMPLE_INTERVAL=0
+
+KFENCE provides several other configuration options to customize behaviour (see
+the respective help text in ``lib/Kconfig.kfence`` for more info).
+
+Tuning performance
+~~~~~~~~~~~~~~~~~~
+
+The most important parameter is KFENCE's sample interval, which can be set via
+the kernel boot parameter ``kfence.sample_interval`` in milliseconds. The
+sample interval determines the frequency with which heap allocations will be
+guarded by KFENCE. The default is configurable via the Kconfig option
+``CONFIG_KFENCE_SAMPLE_INTERVAL``. Setting ``kfence.sample_interval=0``
+disables KFENCE.
+
+The KFENCE memory pool is of fixed size, and if the pool is exhausted, no
+further KFENCE allocations occur. With ``CONFIG_KFENCE_NUM_OBJECTS`` (default
+255), the number of available guarded objects can be controlled. Each object
+requires 2 pages, one for the object itself and the other one used as a guard
+page; object pages are interleaved with guard pages, and every object page is
+therefore surrounded by two guard pages.
+
+The total memory dedicated to the KFENCE memory pool can be computed as::
+
+    ( #objects + 1 ) * 2 * PAGE_SIZE
+
+Using the default config, and assuming a page size of 4 KiB, results in
+dedicating 2 MiB to the KFENCE memory pool.
+
+Note: On architectures that support huge pages, KFENCE will ensure that the
+pool is using pages of size ``PAGE_SIZE``. This will result in additional page
+tables being allocated.
+
+Error reports
+~~~~~~~~~~~~~
+
+A typical out-of-bounds access looks like this::
+
+    ==================================================================
+    BUG: KFENCE: out-of-bounds in test_out_of_bounds_read+0xa3/0x22b
+
+    Out-of-bounds access at 0xffffffffb672efff (1B left of kfence-#17):
+     test_out_of_bounds_read+0xa3/0x22b
+     kunit_try_run_case+0x51/0x85
+     kunit_generic_run_threadfn_adapter+0x16/0x30
+     kthread+0x137/0x160
+     ret_from_fork+0x22/0x30
+
+    kfence-#17 [0xffffffffb672f000-0xffffffffb672f01f, size=32, cache=kmalloc-32] allocated by task 507:
+     test_alloc+0xf3/0x25b
+     test_out_of_bounds_read+0x98/0x22b
+     kunit_try_run_case+0x51/0x85
+     kunit_generic_run_threadfn_adapter+0x16/0x30
+     kthread+0x137/0x160
+     ret_from_fork+0x22/0x30
+
+    CPU: 4 PID: 107 Comm: kunit_try_catch Not tainted 5.8.0-rc6+ #7
+    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
+    ==================================================================
+
+The header of the report provides a short summary of the function involved in
+the access. It is followed by more detailed information about the access and
+its origin. Note that, real kernel addresses are only shown for
+``CONFIG_DEBUG_KERNEL=y`` builds.
+
+Use-after-free accesses are reported as::
+
+    ==================================================================
+    BUG: KFENCE: use-after-free in test_use_after_free_read+0xb3/0x143
+
+    Use-after-free access at 0xffffffffb673dfe0 (in kfence-#24):
+     test_use_after_free_read+0xb3/0x143
+     kunit_try_run_case+0x51/0x85
+     kunit_generic_run_threadfn_adapter+0x16/0x30
+     kthread+0x137/0x160
+     ret_from_fork+0x22/0x30
+
+    kfence-#24 [0xffffffffb673dfe0-0xffffffffb673dfff, size=32, cache=kmalloc-32] allocated by task 507:
+     test_alloc+0xf3/0x25b
+     test_use_after_free_read+0x76/0x143
+     kunit_try_run_case+0x51/0x85
+     kunit_generic_run_threadfn_adapter+0x16/0x30
+     kthread+0x137/0x160
+     ret_from_fork+0x22/0x30
+
+    freed by task 507:
+     test_use_after_free_read+0xa8/0x143
+     kunit_try_run_case+0x51/0x85
+     kunit_generic_run_threadfn_adapter+0x16/0x30
+     kthread+0x137/0x160
+     ret_from_fork+0x22/0x30
+
+    CPU: 4 PID: 109 Comm: kunit_try_catch Tainted: G        W         5.8.0-rc6+ #7
+    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
+    ==================================================================
+
+KFENCE also reports on invalid frees, such as double-frees::
+
+    ==================================================================
+    BUG: KFENCE: invalid free in test_double_free+0xdc/0x171
+
+    Invalid free of 0xffffffffb6741000:
+     test_double_free+0xdc/0x171
+     kunit_try_run_case+0x51/0x85
+     kunit_generic_run_threadfn_adapter+0x16/0x30
+     kthread+0x137/0x160
+     ret_from_fork+0x22/0x30
+
+    kfence-#26 [0xffffffffb6741000-0xffffffffb674101f, size=32, cache=kmalloc-32] allocated by task 507:
+     test_alloc+0xf3/0x25b
+     test_double_free+0x76/0x171
+     kunit_try_run_case+0x51/0x85
+     kunit_generic_run_threadfn_adapter+0x16/0x30
+     kthread+0x137/0x160
+     ret_from_fork+0x22/0x30
+
+    freed by task 507:
+     test_double_free+0xa8/0x171
+     kunit_try_run_case+0x51/0x85
+     kunit_generic_run_threadfn_adapter+0x16/0x30
+     kthread+0x137/0x160
+     ret_from_fork+0x22/0x30
+
+    CPU: 4 PID: 111 Comm: kunit_try_catch Tainted: G        W         5.8.0-rc6+ #7
+    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
+    ==================================================================
+
+KFENCE also uses pattern-based redzones on the other side of an object's guard
+page, to detect out-of-bounds writes on the unprotected side of the object.
+These are reported on frees::
+
+    ==================================================================
+    BUG: KFENCE: memory corruption in test_kmalloc_aligned_oob_write+0xef/0x184
+
+    Corrupted memory at 0xffffffffb6797ff9 [ 0xac . . . . . . ] (in kfence-#69):
+     test_kmalloc_aligned_oob_write+0xef/0x184
+     kunit_try_run_case+0x51/0x85
+     kunit_generic_run_threadfn_adapter+0x16/0x30
+     kthread+0x137/0x160
+     ret_from_fork+0x22/0x30
+
+    kfence-#69 [0xffffffffb6797fb0-0xffffffffb6797ff8, size=73, cache=kmalloc-96] allocated by task 507:
+     test_alloc+0xf3/0x25b
+     test_kmalloc_aligned_oob_write+0x57/0x184
+     kunit_try_run_case+0x51/0x85
+     kunit_generic_run_threadfn_adapter+0x16/0x30
+     kthread+0x137/0x160
+     ret_from_fork+0x22/0x30
+
+    CPU: 4 PID: 120 Comm: kunit_try_catch Tainted: G        W         5.8.0-rc6+ #7
+    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
+    ==================================================================
+
+For such errors, the address where the corruption occurred as well as the
+invalidly written bytes (offset from the address) are shown; in this
+representation, '.' denote untouched bytes. In the example above ``0xac`` is
+the value written to the invalid address at offset 0, and the remaining '.'
+denote that no following bytes have been touched. Note that, real values are
+only shown for ``CONFIG_DEBUG_KERNEL=y`` builds; to avoid information
+disclosure for non-debug builds, '!' is used instead to denote invalidly
+written bytes.
+
+And finally, KFENCE may also report on invalid accesses to any protected page
+where it was not possible to determine an associated object, e.g. if adjacent
+object pages had not yet been allocated::
+
+    ==================================================================
+    BUG: KFENCE: invalid access in test_invalid_access+0x26/0xe0
+
+    Invalid access at 0xffffffffb670b00a:
+     test_invalid_access+0x26/0xe0
+     kunit_try_run_case+0x51/0x85
+     kunit_generic_run_threadfn_adapter+0x16/0x30
+     kthread+0x137/0x160
+     ret_from_fork+0x22/0x30
+
+    CPU: 4 PID: 124 Comm: kunit_try_catch Tainted: G        W         5.8.0-rc6+ #7
+    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
+    ==================================================================
+
+DebugFS interface
+~~~~~~~~~~~~~~~~~
+
+Some debugging information is exposed via debugfs:
+
+* The file ``/sys/kernel/debug/kfence/stats`` provides runtime statistics.
+
+* The file ``/sys/kernel/debug/kfence/objects`` provides a list of objects
+  allocated via KFENCE, including those already freed but protected.
+
+Implementation Details
+----------------------
+
+Guarded allocations are set up based on the sample interval. After expiration
+of the sample interval, the next allocation through the main allocator (SLAB or
+SLUB) returns a guarded allocation from the KFENCE object pool (allocation
+sizes up to PAGE_SIZE are supported). At this point, the timer is reset, and
+the next allocation is set up after the expiration of the interval. To "gate" a
+KFENCE allocation through the main allocator's fast-path without overhead,
+KFENCE relies on static branches via the static keys infrastructure. The static
+branch is toggled to redirect the allocation to KFENCE.
+
+KFENCE objects each reside on a dedicated page, at either the left or right
+page boundaries selected at random. The pages to the left and right of the
+object page are "guard pages", whose attributes are changed to a protected
+state, and cause page faults on any attempted access. Such page faults are then
+intercepted by KFENCE, which handles the fault gracefully by reporting an
+out-of-bounds access, and marking the page as accessible so that the faulting
+code can (wrongly) continue executing (set ``panic_on_warn`` to panic instead).
+
+To detect out-of-bounds writes to memory within the object's page itself,
+KFENCE also uses pattern-based redzones. For each object page, a redzone is set
+up for all non-object memory. For typical alignments, the redzone is only
+required on the unguarded side of an object. Because KFENCE must honor the
+cache's requested alignment, special alignments may result in unprotected gaps
+on either side of an object, all of which are redzoned.
+
+The following figure illustrates the page layout::
+
+    ---+-----------+-----------+-----------+-----------+-----------+---
+       | xxxxxxxxx | O :       | xxxxxxxxx |       : O | xxxxxxxxx |
+       | xxxxxxxxx | B :       | xxxxxxxxx |       : B | xxxxxxxxx |
+       | x GUARD x | J : RED-  | x GUARD x | RED-  : J | x GUARD x |
+       | xxxxxxxxx | E :  ZONE | xxxxxxxxx |  ZONE : E | xxxxxxxxx |
+       | xxxxxxxxx | C :       | xxxxxxxxx |       : C | xxxxxxxxx |
+       | xxxxxxxxx | T :       | xxxxxxxxx |       : T | xxxxxxxxx |
+    ---+-----------+-----------+-----------+-----------+-----------+---
+
+Upon deallocation of a KFENCE object, the object's page is again protected and
+the object is marked as freed. Any further access to the object causes a fault
+and KFENCE reports a use-after-free access. Freed objects are inserted at the
+tail of KFENCE's freelist, so that the least recently freed objects are reused
+first, and the chances of detecting use-after-frees of recently freed objects
+is increased.
+
+Interface
+---------
+
+The following describes the functions which are used by allocators as well as
+page handling code to set up and deal with KFENCE allocations.
+
+.. kernel-doc:: include/linux/kfence.h
+   :functions: is_kfence_address
+               kfence_shutdown_cache
+               kfence_alloc kfence_free __kfence_free
+               kfence_ksize kfence_object_start
+               kfence_handle_page_fault
+
+Related Tools
+-------------
+
+In userspace, a similar approach is taken by `GWP-ASan
+<http://llvm.org/docs/GwpAsan.html>`_. GWP-ASan also relies on guard pages and
+a sampling strategy to detect memory unsafety bugs at scale. KFENCE's design is
+directly influenced by GWP-ASan, and can be seen as its kernel sibling. Another
+similar but non-sampling approach, that also inspired the name "KFENCE", can be
+found in the userspace `Electric Fence Malloc Debugger
+<https://linux.die.net/man/3/efence>`_.
+
+In the kernel, several tools exist to debug memory access errors, and in
+particular KASAN can detect all bug classes that KFENCE can detect. While KASAN
+is more precise, relying on compiler instrumentation, this comes at a
+performance cost.
+
+It is worth highlighting that KASAN and KFENCE are complementary, with
+different target environments. For instance, KASAN is the better debugging-aid,
+where test cases or reproducers exists: due to the lower chance to detect the
+error, it would require more effort using KFENCE to debug. Deployments at scale
+that cannot afford to enable KASAN, however, would benefit from using KFENCE to
+discover bugs due to code paths not exercised by test cases or fuzzers.
--- a/lib/Kconfig.kfence~kfence-documentation-add-kfence-documentation
+++ a/lib/Kconfig.kfence
@@ -14,6 +14,8 @@ menuconfig KFENCE
 	  to have negligible cost to permit enabling it in production
 	  environments.
 
+	  See <file:Documentation/dev-tools/kfence.rst> for more details.
+
 	  Note that, KFENCE is not a substitute for explicit testing with tools
 	  such as KASAN. KFENCE can detect a subset of bugs that KASAN can
 	  detect, albeit at very different performance profiles. If you can
_

Patches currently in -mm which might be from elver@google.com are

arm64-kfence-enable-kfence-for-arm64.patch
kfence-documentation-add-kfence-documentation.patch
kfence-add-test-suite.patch
maintainers-add-entry-for-kfence.patch

