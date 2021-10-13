Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8ED4C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 22:52:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF2E96023B
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 22:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhJMWyh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Oct 2021 18:54:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229930AbhJMWyh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 Oct 2021 18:54:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FD3361040;
        Wed, 13 Oct 2021 22:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634165553;
        bh=Mj+fcYrLac8FWgmDL2u52d7qLmQsxPYOuADHv2FnYz8=;
        h=Date:From:To:Subject:From;
        b=un+WW84qC0f+sXfL7e+EOet9G9l92X5E0w7bND46vcr9mah/h0juxUxXHpZ8IeFoa
         q4y4fOBXHtzc9QYCN8FW6EcZwc5NABjGEP/1EhZHpAJ3kgP0nM1aNzsWMSGImu3cif
         VmtC42GdR6IQTu6+nc1ir0B9WqHLMZApz/+H+2F0=
Date:   Wed, 13 Oct 2021 15:52:32 -0700
From:   akpm@linux-foundation.org
To:     amit@kernel.org, benh@kernel.crashing.org,
        brendanhiggins@google.com, corbet@lwn.net, david@redhat.com,
        dwmw@amazon.com, elver@google.com, foersleo@amazon.de,
        gthelen@google.com, Jonathan.Cameron@huawei.com, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org
Subject:  +
 docs-damon-document-physical-memory-monitoring-support.patch added to -mm
 tree
Message-ID: <20211013225232.-fokPBvG_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/DAMON: document physical memory monitoring support
has been added to the -mm tree.  Its filename is
     docs-damon-document-physical-memory-monitoring-support.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/docs-damon-document-physical-=
memory-monitoring-support.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/docs-damon-document-physical-=
memory-monitoring-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: SeongJae Park <sj@kernel.org>
Subject: Docs/DAMON: document physical memory monitoring support

This commit updates the DAMON documents for the physical memory address
space monitoring support.

Link: https://lkml.kernel.org/r/20211012205711.29216-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Amit Shah <amit@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rienjes <rientjes@google.com>
Cc: David Woodhouse <dwmw@amazon.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Marco Elver <elver@google.com>
Cc: Markus Boehme <markubo@amazon.de>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   25 +++++++++++---
 Documentation/vm/damon/design.rst            |   29 ++++++++++-------
 Documentation/vm/damon/faq.rst               |    5 +-
 3 files changed, 40 insertions(+), 19 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-damon-document-phys=
ical-memory-monitoring-support
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -10,15 +10,16 @@ DAMON provides below three interfaces fo
   This is for privileged people such as system administrators who want a
   just-working human-friendly interface.  Using this, users can use the DA=
MON=E2=80=99s
   major features in a human-friendly way.  It may not be highly tuned for
-  special cases, though.  It supports only virtual address spaces monitori=
ng.
+  special cases, though.  It supports both virtual and physical address sp=
aces
+  monitoring.
 - *debugfs interface.*
   This is for privileged user space programmers who want more optimized us=
e of
   DAMON.  Using this, users can use DAMON=E2=80=99s major features by read=
ing
   from and writing to special debugfs files.  Therefore, you can write and=
 use
   your personalized DAMON debugfs wrapper programs that reads/writes the
   debugfs files instead of you.  The DAMON user space tool is also a refer=
ence
-  implementation of such programs.  It supports only virtual address spaces
-  monitoring.
+  implementation of such programs.  It supports both virtual and physical
+  address spaces monitoring.
 - *Kernel Space Programming Interface.*
   This is for kernel space programmers.  Using this, users can utilize eve=
ry
   feature of DAMON most flexibly and efficiently by writing kernel space
@@ -72,20 +73,34 @@ check it again::
     # cat target_ids
     42 4242
=20
+Users can also monitor the physical memory address space of the system by
+writing a special keyword, "``paddr\n``" to the file.  Because physical ad=
dress
+space monitoring doesn't support multiple targets, reading the file will s=
how a
+fake value, ``42``, as below::
+
+    # cd <debugfs>/damon
+    # echo paddr > target_ids
+    # cat target_ids
+    42
+
 Note that setting the target ids doesn't start the monitoring.
=20
=20
 Initial Monitoring Target Regions
 ---------------------------------
=20
-In case of the debugfs based monitoring, DAMON automatically sets and upda=
tes
-the monitoring target regions so that entire memory mappings of target
+In case of the virtual address space monitoring, DAMON automatically sets =
and
+updates the monitoring target regions so that entire memory mappings of ta=
rget
 processes can be covered.  However, users can want to limit the monitoring
 region to specific address ranges, such as the heap, the stack, or specific
 file-mapped area.  Or, some users can know the initial access pattern of t=
heir
 workloads and therefore want to set optimal initial regions for the 'adapt=
ive
 regions adjustment'.
=20
+In contrast, DAMON do not automatically sets and updates the monitoring ta=
rget
+regions in case of physical memory monitoring.  Therefore, users should se=
t the
+monitoring target regions by themselves.
+
 In such cases, users can explicitly set the initial monitoring target regi=
ons
 as they want, by writing proper values to the ``init_regions`` file.  Each=
 line
 of the input should represent one region in below form.::
--- a/Documentation/vm/damon/design.rst~docs-damon-document-physical-memory=
-monitoring-support
+++ a/Documentation/vm/damon/design.rst
@@ -35,13 +35,17 @@ two parts:
 1. Identification of the monitoring target address range for the address s=
pace.
 2. Access check of specific address range in the target space.
=20
-DAMON currently provides the implementation of the primitives for only the
-virtual address spaces. Below two subsections describe how it works.
+DAMON currently provides the implementations of the primitives for the phy=
sical
+and virtual address spaces. Below two subsections describe how those work.
=20
=20
 VMA-based Target Address Range Construction
 -------------------------------------------
=20
+This is only for the virtual address space primitives implementation.  Tha=
t for
+the physical address space simply asks users to manually set the monitoring
+target address ranges.
+
 Only small parts in the super-huge virtual address space of the processes =
are
 mapped to the physical memory and accessed.  Thus, tracking the unmapped
 address regions is just wasteful.  However, because DAMON can deal with so=
me
@@ -71,15 +75,18 @@ to make a reasonable trade-off.  Below s
 PTE Accessed-bit Based Access Check
 -----------------------------------
=20
-The implementation for the virtual address space uses PTE Accessed-bit for
-basic access checks.  It finds the relevant PTE Accessed bit from the addr=
ess
-by walking the page table for the target task of the address.  In this way=
, the
-implementation finds and clears the bit for next sampling target address a=
nd
-checks whether the bit set again after one sampling period.  This could di=
sturb
-other kernel subsystems using the Accessed bits, namely Idle page tracking=
 and
-the reclaim logic.  To avoid such disturbances, DAMON makes it mutually
-exclusive with Idle page tracking and uses ``PG_idle`` and ``PG_young`` pa=
ge
-flags to solve the conflict with the reclaim logic, as Idle page tracking =
does.
+Both of the implementations for physical and virtual address spaces use PTE
+Accessed-bit for basic access checks.  Only one difference is the way of
+finding the relevant PTE Accessed bit(s) from the address.  While the
+implementation for the virtual address walks the page table for the target=
 task
+of the address, the implementation for the physical address walks every pa=
ge
+table having a mapping to the address.  In this way, the implementations f=
ind
+and clear the bit(s) for next sampling target address and checks whether t=
he
+bit(s) set again after one sampling period.  This could disturb other kern=
el
+subsystems using the Accessed bits, namely Idle page tracking and the recl=
aim
+logic.  To avoid such disturbances, DAMON makes it mutually exclusive with=
 Idle
+page tracking and uses ``PG_idle`` and ``PG_young`` page flags to solve the
+conflict with the reclaim logic, as Idle page tracking does.
=20
=20
 Address Space Independent Core Mechanisms
--- a/Documentation/vm/damon/faq.rst~docs-damon-document-physical-memory-mo=
nitoring-support
+++ a/Documentation/vm/damon/faq.rst
@@ -36,10 +36,9 @@ constructions and actual access checks c
 DAMON core by the users.  In this way, DAMON users can monitor any address
 space with any access check technique.
=20
-Nonetheless, DAMON provides vma tracking and PTE Accessed bit check based
+Nonetheless, DAMON provides vma/rmap tracking and PTE Accessed bit check b=
ased
 implementations of the address space dependent functions for the virtual m=
emory
-by default, for a reference and convenient use.  In near future, we will
-provide those for physical memory address space.
+and the physical memory by default, for a reference and convenient use.
=20
=20
 Can I simply monitor page granularity?
_

Patches currently in -mm which might be from sj@kernel.org are

maintainers-update-seongjaes-email-address.patch
mm-damon-core-print-kdamond-start-log-in-debug-mode-only.patch
mm-damon-core-account-age-of-target-regions.patch
mm-damon-core-implement-damon-based-operation-schemes-damos.patch
mm-damon-vaddr-support-damon-based-operation-schemes.patch
mm-damon-dbgfs-support-damon-based-operation-schemes.patch
mm-damon-schemes-implement-statistics-feature.patch
selftests-damon-add-schemes-debugfs-tests.patch
docs-admin-guide-mm-damon-document-damon-based-operation-schemes.patch
mm-damon-dbgfs-allow-users-to-set-initial-monitoring-target-regions.patch
mm-damon-dbgfs-test-add-a-unit-test-case-for-init_regions.patch
docs-admin-guide-mm-damon-document-init_regions-feature.patch
mm-damon-vaddr-separate-commonly-usable-functions.patch
mm-damon-implement-primitives-for-physical-address-space-monitoring.patch
mm-damon-dbgfs-support-physical-memory-monitoring.patch
docs-damon-document-physical-memory-monitoring-support.patch

