Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F49C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Dec 2021 20:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhLIUgE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Dec 2021 15:36:04 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:33044 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhLIUgD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2021 15:36:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D731ACE25F1
        for <mm-commits@vger.kernel.org>; Thu,  9 Dec 2021 20:32:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5ABC341CA;
        Thu,  9 Dec 2021 20:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639081947;
        bh=mP+nJ8KPWs5MppWM9CsgyxtmStgrrlrmAcIo8dnYKOA=;
        h=Date:From:To:Subject:From;
        b=BcO8QN5HU3EYomnFq5l6UX/C0u9Nss9QWBXWH3cgg2fjM2FOS4Vws4fyuXM44Q1Ez
         QGrHLosLT5RiKnBeP1fZRsCvXyWOJqxTEjbhs/gD3+hrMNDiYGvdP49QTo0y+mHwUJ
         rrtLQnLq+YPaIQ5WTBVID6gUcPB4b1yaOibew+fA=
Date:   Thu, 09 Dec 2021 12:32:26 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, mm-commits@vger.kernel.org, sj@kernel.org
Subject:  +
 docs-admin-guide-mm-damon-usage-remove-redundant-information.patch added to
 -mm tree
Message-ID: <20211209203226.x767tFUq4%akpm@linux-foundation.org>
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
has been added to the -mm tree.  Its filename is
     docs-admin-guide-mm-damon-usage-remove-redundant-information.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/docs-admin-guide-mm-damon-usa=
ge-remove-redundant-information.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/docs-admin-guide-mm-damon-usa=
ge-remove-redundant-information.patch

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

timers-implement-usleep_idle_range.patch
mm-damon-core-fix-fake-load-reports-due-to-uninterruptible-sleeps.patch
mm-damon-core-use-better-timer-mechanisms-selection-threshold.patch
mm-damon-dbgfs-remove-an-unnecessary-error-message.patch
mm-damon-core-remove-unnecessary-error-messages.patch
mm-damon-vaddr-remove-an-unnecessary-warning-message.patch
mm-damon-vaddr-test-split-a-test-function-having-1024-bytes-frame-size.patch
mm-damon-vaddr-test-remove-unnecessary-variables.patch
selftests-damon-skip-test-if-damon-is-running.patch
selftests-damon-test-damon-enabling-with-empty-target_ids-case.patch
selftests-damon-test-wrong-damos-condition-ranges-input.patch
selftests-damon-test-debugfs-file-reads-writes-with-huge-count.patch
selftests-damon-split-test-cases.patch
mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix.patch
mm-damon-convert-macro-functions-to-static-inline-functions.patch
docs-admin-guide-mm-damon-usage-update-for-scheme-quotas-and-watermarks.pat=
ch
docs-admin-guide-mm-damon-usage-remove-redundant-information.patch
docs-admin-guide-mm-damon-usage-mention-tracepoint-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-for-kdamond_pid-and-mkrm_contexts.pa=
tch
mm-damon-remove-a-mistakenly-added-comment-for-a-future-feature.patch

