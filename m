Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C77A6C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347906AbiATV2k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:28:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59036 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244349AbiATV2k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:28:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B892B81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98952C340E3;
        Thu, 20 Jan 2022 21:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714117;
        bh=jUBTKtgNfiut6r+MsFluV2ceN9w57KlCdgBHJey3uQA=;
        h=Date:From:To:Subject:From;
        b=tVUaa0at+KZfQusP0hTa43mwPgcoZltem1SIZjP8HinRwdCvGw/Ju3+UGuM+tBsJa
         vG29+bXwC325q6wQoVzXEqr7/JQeuBdyi0J+XBV30zXspHu+H/TvzQljC+7POs2nc6
         u06VMFtBZyGMia0qh8183yVYCNGYvwxUSAx/TKNs=
Date:   Thu, 20 Jan 2022 13:28:37 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, mm-commits@vger.kernel.org, sj@kernel.org
Subject:  [merged]
 docs-admin-guide-mm-damon-usage-remove-redundant-information.patch removed
 from -mm tree
Message-ID: <20220120212837._T-lIIy8b%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: remove redundant information
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-remove-redundant-information.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
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

Patches currently in -mm which might be from sj@kernel.org are


