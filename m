Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF0B2C64ED8
	for <mm-commits@archiver.kernel.org>; Mon, 27 Feb 2023 22:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjB0WK6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Feb 2023 17:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjB0WK5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2023 17:10:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEDC2748C
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 14:10:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 759B960F2F
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 22:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DE1C433EF;
        Mon, 27 Feb 2023 22:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677535854;
        bh=O5/HMXpOCXG8mKs4ruq95m8u9gosKkhMDLestl921A0=;
        h=Date:To:From:Subject:From;
        b=NqfLm6mO32h5uLhojg+zmEZxN+hwOo0tCOz9I8SVi6qRF0Cdjr6QG21fDzaRtzBBi
         WSErH8ylzPwTxy5OmzTxYce0wUu92yEas1OK6rLukPxvz6cmbl9f+wGxtZxbMRabDn
         2dtEHPFZsueqXQ/VEkqli4M1/49W58UJUFTvQ+LI=
Date:   Mon, 27 Feb 2023 14:10:54 -0800
To:     mm-commits@vger.kernel.org, glider@google.com, elver@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-improve-documentation.patch added to mm-nonmm-unstable branch
Message-Id: <20230227221054.C4DE1C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: improve documentation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kcov-improve-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcov-improve-documentation.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kcov: improve documentation
Date: Mon, 27 Feb 2023 18:17:03 +0100

Improve KCOV documentation:

- Use KCOV instead of kcov, as the former is more widely-used.

- Mention Clang in compiler requirements.

- Use ``annotations`` for inline code.

- Rework remote coverage collection documentation for better clarity.

- Various smaller changes.

Link: https://lkml.kernel.org/r/0b5efd70e31bba7912cf9a6c951f0e76a8df27df.1677517724.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/dev-tools/kcov.rst~kcov-improve-documentation
+++ a/Documentation/dev-tools/kcov.rst
@@ -1,42 +1,50 @@
-kcov: code coverage for fuzzing
+KCOV: code coverage for fuzzing
 ===============================
 
-kcov exposes kernel code coverage information in a form suitable for coverage-
-guided fuzzing (randomized testing). Coverage data of a running kernel is
-exported via the "kcov" debugfs file. Coverage collection is enabled on a task
-basis, and thus it can capture precise coverage of a single system call.
-
-Note that kcov does not aim to collect as much coverage as possible. It aims
-to collect more or less stable coverage that is function of syscall inputs.
-To achieve this goal it does not collect coverage in soft/hard interrupts
-and instrumentation of some inherently non-deterministic parts of kernel is
-disabled (e.g. scheduler, locking).
-
-kcov is also able to collect comparison operands from the instrumented code
-(this feature currently requires that the kernel is compiled with clang).
+KCOV collects and exposes kernel code coverage information in a form suitable
+for coverage-guided fuzzing. Coverage data of a running kernel is exported via
+the ``kcov`` debugfs file. Coverage collection is enabled on a task basis, and
+thus KCOV can capture precise coverage of a single system call.
+
+Note that KCOV does not aim to collect as much coverage as possible. It aims
+to collect more or less stable coverage that is a function of syscall inputs.
+To achieve this goal, it does not collect coverage in soft/hard interrupts
+(unless remove coverage collection is enabled, see below) and from some
+inherently non-deterministic parts of the kernel (e.g. scheduler, locking).
+
+Besides collecting code coverage, KCOV can also collect comparison operands.
+See the "Comparison operands collection" section for details.
+
+Besides collecting coverage data from syscall handlers, KCOV can also collect
+coverage for annotated parts of the kernel executing in background kernel
+tasks or soft interrupts. See the "Remote coverage collection" section for
+details.
 
 Prerequisites
 -------------
 
-Configure the kernel with::
+KCOV relies on compiler instrumentation and requires GCC 6.1.0 or later
+or any Clang version supported by the kernel.
 
-        CONFIG_KCOV=y
+Collecting comparison operands is only supported with Clang.
 
-CONFIG_KCOV requires gcc 6.1.0 or later.
+To enable KCOV, configure the kernel with::
 
-If the comparison operands need to be collected, set::
+        CONFIG_KCOV=y
+
+To enable comparison operands collection, set::
 
 	CONFIG_KCOV_ENABLE_COMPARISONS=y
 
-Profiling data will only become accessible once debugfs has been mounted::
+Coverage data only becomes accessible once debugfs has been mounted::
 
         mount -t debugfs none /sys/kernel/debug
 
 Coverage collection
 -------------------
 
-The following program demonstrates coverage collection from within a test
-program using kcov:
+The following program demonstrates how to use KCOV to collect coverage for a
+single syscall from within a test program:
 
 .. code-block:: c
 
@@ -84,7 +92,7 @@ program using kcov:
 		perror("ioctl"), exit(1);
 	/* Reset coverage from the tail of the ioctl() call. */
 	__atomic_store_n(&cover[0], 0, __ATOMIC_RELAXED);
-	/* That's the target syscal call. */
+	/* Call the target syscall call. */
 	read(-1, NULL, 0);
 	/* Read number of PCs collected. */
 	n = __atomic_load_n(&cover[0], __ATOMIC_RELAXED);
@@ -103,7 +111,7 @@ program using kcov:
 	return 0;
     }
 
-After piping through addr2line output of the program looks as follows::
+After piping through ``addr2line`` the output of the program looks as follows::
 
     SyS_read
     fs/read_write.c:562
@@ -121,12 +129,13 @@ After piping through addr2line output of
     fs/read_write.c:562
 
 If a program needs to collect coverage from several threads (independently),
-it needs to open /sys/kernel/debug/kcov in each thread separately.
+it needs to open ``/sys/kernel/debug/kcov`` in each thread separately.
 
 The interface is fine-grained to allow efficient forking of test processes.
-That is, a parent process opens /sys/kernel/debug/kcov, enables trace mode,
-mmaps coverage buffer and then forks child processes in a loop. Child processes
-only need to enable coverage (disable happens automatically on thread end).
+That is, a parent process opens ``/sys/kernel/debug/kcov``, enables trace mode,
+mmaps coverage buffer, and then forks child processes in a loop. The child
+processes only need to enable coverage (it gets disabled automatically when
+a thread exits).
 
 Comparison operands collection
 ------------------------------
@@ -205,52 +214,78 @@ Comparison operands collection is simila
 	return 0;
     }
 
-Note that the kcov modes (coverage collection or comparison operands) are
-mutually exclusive.
+Note that the KCOV modes (collection of code coverage or comparison operands)
+are mutually exclusive.
 
 Remote coverage collection
 --------------------------
 
-With KCOV_ENABLE coverage is collected only for syscalls that are issued
-from the current process. With KCOV_REMOTE_ENABLE it's possible to collect
-coverage for arbitrary parts of the kernel code, provided that those parts
-are annotated with kcov_remote_start()/kcov_remote_stop().
-
-This allows to collect coverage from two types of kernel background
-threads: the global ones, that are spawned during kernel boot in a limited
-number of instances (e.g. one USB hub_event() worker thread is spawned per
-USB HCD); and the local ones, that are spawned when a user interacts with
-some kernel interface (e.g. vhost workers); as well as from soft
-interrupts.
-
-To enable collecting coverage from a global background thread or from a
-softirq, a unique global handle must be assigned and passed to the
-corresponding kcov_remote_start() call. Then a userspace process can pass
-a list of such handles to the KCOV_REMOTE_ENABLE ioctl in the handles
-array field of the kcov_remote_arg struct. This will attach the used kcov
-device to the code sections, that are referenced by those handles.
-
-Since there might be many local background threads spawned from different
-userspace processes, we can't use a single global handle per annotation.
-Instead, the userspace process passes a non-zero handle through the
-common_handle field of the kcov_remote_arg struct. This common handle gets
-saved to the kcov_handle field in the current task_struct and needs to be
-passed to the newly spawned threads via custom annotations. Those threads
-should in turn be annotated with kcov_remote_start()/kcov_remote_stop().
-
-Internally kcov stores handles as u64 integers. The top byte of a handle
-is used to denote the id of a subsystem that this handle belongs to, and
-the lower 4 bytes are used to denote the id of a thread instance within
-that subsystem. A reserved value 0 is used as a subsystem id for common
-handles as they don't belong to a particular subsystem. The bytes 4-7 are
-currently reserved and must be zero. In the future the number of bytes
-used for the subsystem or handle ids might be increased.
-
-When a particular userspace process collects coverage via a common
-handle, kcov will collect coverage for each code section that is annotated
-to use the common handle obtained as kcov_handle from the current
-task_struct. However non common handles allow to collect coverage
-selectively from different subsystems.
+Besides collecting coverage data from handlers of syscalls issued from a
+userspace process, KCOV can also collect coverage for parts of the kernel
+executing in other contexts - so-called "remote" coverage.
+
+Using KCOV to collect remote coverage requires:
+
+1. Modifying kernel code to annotate the code section from where coverage
+   should be collected with ``kcov_remote_start`` and ``kcov_remote_stop``.
+
+2. Using `KCOV_REMOTE_ENABLE`` instead of ``KCOV_ENABLE`` in the userspace
+   process that collects coverage.
+
+Both ``kcov_remote_start`` and ``kcov_remote_stop`` annotations and the
+``KCOV_REMOTE_ENABLE`` ioctl accept handles that identify particular coverage
+collection sections. The way a handle is used depends on the context where the
+matching code section executes.
+
+KCOV supports collecting remote coverage from the following contexts:
+
+1. Global kernel background tasks. These are the tasks that are spawned during
+   kernel boot in a limited number of instances (e.g. one USB ``hub_event``
+   worker is spawned per one USB HCD).
+
+2. Local kernel background tasks. These are spawned when a userspace process
+   interacts with some kernel interface and are usually killed when the process
+   exits (e.g. vhost workers).
+
+3. Soft interrupts.
+
+For #1 and #3, a unique global handle must be chosen and passed to the
+corresponding ``kcov_remote_start`` call. Then a userspace process must pass
+this handle to ``KCOV_REMOTE_ENABLE`` in the ``handles`` array field of the
+``kcov_remote_arg`` struct. This will attach the used KCOV device to the code
+section referenced by this handle. Multiple global handles identifying
+different code sections can be passed at once.
+
+For #2, the userspace process instead must pass a non-zero handle through the
+``common_handle`` field of the ``kcov_remote_arg`` struct. This common handle
+gets saved to the ``kcov_handle`` field in the current ``task_struct`` and
+needs to be passed to the newly spawned local tasks via custom kernel code
+modifications. Those tasks should in turn use the passed handle in their
+``kcov_remote_start`` and ``kcov_remote_stop`` annotations.
+
+KCOV follows a predefined format for both global and common handles. Each
+handle is a ``u64`` integer. Currently, only the one top and the lower 4 bytes
+are used. Bytes 4-7 are reserved and must be zero.
+
+For global handles, the top byte of the handle denotes the id of a subsystem
+this handle belongs to. For example, KCOV uses ``1`` as the USB subsystem id.
+The lower 4 bytes of a global handle denote the id of a task instance within
+that subsystem. For example, each ``hub_event`` worker uses the USB bus number
+as the task instance id.
+
+For common handles, a reserved value ``0`` is used as a subsystem id, as such
+handles don't belong to a particular subsystem. The lower 4 bytes of a common
+handle identify a collective instance of all local tasks spawned by the
+userspace process that passed a common handle to ``KCOV_REMOTE_ENABLE``.
+
+In practice, any value can be used for common handle instance id if coverage
+is only collected from a single userspace process on the system. However, if
+common handles are used by multiple processes, unique instance ids must be
+used for each process. One option is to use the process id as the common
+handle instance id.
+
+The following program demonstrates using KCOV to collect coverage from both
+local tasks spawned by the process and the global task that handles USB bus #1:
 
 .. code-block:: c
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kcov-improve-documentation.patch

