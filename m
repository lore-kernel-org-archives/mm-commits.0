From: akpm@linux-foundation.org
Subject: + scripts-add-a-intermediate-file-for-make-gtags.patch
 added to -mm tree
Date: Tue, 05 May 2020 13:23:00 -0700
Message-ID: <20200505202300.XXfTIsFdx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbgEEUXC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 May 2020 16:23:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, gregkh@linuxfoundation.org, masahiroy@kernel.org, mchehab+huawei@kernel.org, mm-commits@vger.kernel.org, xujialu@vimux.org


The patch titled
     Subject: scripts/tags.sh: add a intermediate file for 'make gtags'
has been added to the -mm tree.  Its filename is
     scripts-add-a-intermediate-file-for-make-gtags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-add-a-intermediate-fil=
e-for-make-gtags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-add-a-intermediate-fil=
e-for-make-gtags.patch

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
=46rom: xujialu <xujialu@vimux.org>
Subject: scripts/tags.sh: add a intermediate file for 'make gtags'

As 'GTAGS Manual' said: If =C2=B4gtags.files=C2=B4 exists in the current di=
rectory
directory or a file is specified by the -f option, target files are
limited by it.

So add gtags.files just like cscope.files.

Link: http://lkml.kernel.org/r/20200502052619.26457-3-xujialu@vimux.org
Signed-off-by: xujialu <xujialu@vimux.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile        |    2 +-
 scripts/tags.sh |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/Makefile~scripts-add-a-intermediate-file-for-make-gtags
+++ a/Makefile
@@ -1398,7 +1398,7 @@ MRPROPER_FILES +=3D .config .config.old .v
=20
 # Directories & files removed with 'make distclean'
 DISTCLEAN_DIRS  +=3D
-DISTCLEAN_FILES +=3D tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS
+DISTCLEAN_FILES +=3D tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS gtags.files
=20
 # clean - Delete most, but leave enough to build external modules
 #
--- a/scripts/tags.sh~scripts-add-a-intermediate-file-for-make-gtags
+++ a/scripts/tags.sh
@@ -142,7 +142,8 @@ docscope()
=20
 dogtags()
 {
-	all_target_sources | gtags -i -f -
+	all_target_sources > gtags.files
+	gtags -i -f gtags.files
 }
=20
 # Basic regular expressions with an optional /kind-spec/ for ctags and
_

Patches currently in -mm which might be from xujialu@vimux.org are

scripts-support-compiled-source-improved-precise.patch
scripts-add-a-intermediate-file-for-make-gtags.patch
