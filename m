Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E008C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbiANWKL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:10:11 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:38396 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiANWKJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:10:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C6544CE2498
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:10:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA40C36AEC;
        Fri, 14 Jan 2022 22:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198206;
        bh=foC+vPwr0CUjmkhtolXcG3WMcxw4VlfduBgFEN0YHFs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KWeAlBWjRA/CJFZTRFHKoQWXFvcGgnNN9TCU8++z9bE4jP8UgbP7Gj2Nt0OaOsNVl
         Id2KCEVc/q6qwBevqQOO4RaPgVSlChaTJxBO1PNw7R0LxFOe9gRZfyUQ2/OPLFJQO5
         ITEU1CQMWcfn3mzuljee0M36FRM272wn3imme+n4=
Date:   Fri, 14 Jan 2022 14:10:05 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 131/146] Docs/admin-guide/mm/damon/usage: remove
 redundant information
Message-ID: <20220114221005.k_LcZXMlh%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: remove redundant information

DAMON usage document mentions DAMON user space tool and programming
interface twice.  This commit integrates those and remove unnecessary
part.

Link: https://lkml.kernel.org/r/20211209131806.19317-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   42 ++++++++---------
 1 file changed, 21 insertions(+), 21 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damo=
n-usage-remove-redundant-information
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -7,30 +7,30 @@ Detailed Usages
 DAMON provides below three interfaces for different users.
=20
 - *DAMON user space tool.*
-  This is for privileged people such as system administrators who want a
-  just-working human-friendly interface.  Using this, users can use the DA=
MON=E2=80=99s
-  major features in a human-friendly way.  It may not be highly tuned for
-  special cases, though.  It supports both virtual and physical address sp=
aces
-  monitoring.
+  `This <https://github.com/awslabs/damo>`_ is for privileged people such =
as
+  system administrators who want a just-working human-friendly interface.
+  Using this, users can use the DAMON=E2=80=99s major features in a human-=
friendly way.
+  It may not be highly tuned for special cases, though.  It supports both
+  virtual and physical address spaces monitoring.  For more detail, please
+  refer to its `usage document
+  <https://github.com/awslabs/damo/blob/next/USAGE.md>`_.
 - *debugfs interface.*
-  This is for privileged user space programmers who want more optimized us=
e of
-  DAMON.  Using this, users can use DAMON=E2=80=99s major features by read=
ing
-  from and writing to special debugfs files.  Therefore, you can write and=
 use
-  your personalized DAMON debugfs wrapper programs that reads/writes the
-  debugfs files instead of you.  The DAMON user space tool is also a refer=
ence
-  implementation of such programs.  It supports both virtual and physical
-  address spaces monitoring.
+  :ref:`This <debugfs_interface>` is for privileged user space programmers=
 who
+  want more optimized use of DAMON.  Using this, users can use DAMON=E2=80=
=99s major
+  features by reading from and writing to special debugfs files.  Therefor=
e,
+  you can write and use your personalized DAMON debugfs wrapper programs t=
hat
+  reads/writes the debugfs files instead of you.  The `DAMON user space to=
ol
+  <https://github.com/awslabs/damo>`_ is one example of such programs.  It
+  supports both virtual and physical address spaces monitoring.
 - *Kernel Space Programming Interface.*
-  This is for kernel space programmers.  Using this, users can utilize eve=
ry
-  feature of DAMON most flexibly and efficiently by writing kernel space
-  DAMON application programs for you.  You can even extend DAMON for vario=
us
-  address spaces.
+  :doc:`This </vm/damon/api>` is for kernel space programmers.  Using this,
+  users can utilize every feature of DAMON most flexibly and efficiently by
+  writing kernel space DAMON application programs for you.  You can even e=
xtend
+  DAMON for various address spaces.  For detail, please refer to the inter=
face
+  :doc:`document </vm/damon/api>`.
=20
-Nevertheless, you could write your own user space tool using the debugfs
-interface.  A reference implementation is available at
-https://github.com/awslabs/damo.  If you are a kernel programmer, you could
-refer to :doc:`/vm/damon/api` for the kernel space programming interface. =
 For
-the reason, this document describes only the debugfs interface
+
+.. _debugfs_interface:
=20
 debugfs Interface
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
_
