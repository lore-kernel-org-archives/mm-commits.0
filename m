From: akpm@linux-foundation.org
Subject: + builddeb-remove-debian-files-before-build.patch added to -mm
 tree
Date: Mon, 05 Oct 2015 13:49:48 -0700
Message-ID: <5612e26c.HB4NzrI8GRVcpbB4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbbJEUtt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2015 16:49:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riku.voipio@linaro.org, ben@decadent.org.uk, chris.j.arges@canonical.com, dsmythies@telus.net, kvalo@codeaurora.org, maks@stro.at, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: builddeb: remove debian/files before build
has been added to the -mm tree.  Its filename is
     builddeb-remove-debian-files-before-build.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/builddeb-remove-debian-files-before-build.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/builddeb-remove-debian-files-before-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Riku Voipio <riku.voipio@linaro.org>
Subject: builddeb: remove debian/files before build

As debian/files keeps accumulating entries, the changes file will end up
growing indefinelty.  Remove the file in clean rule and before build
starts.

Fixes: 3716001bcb7f ("deb-pkg: add source package")
Signed-off-by: Riku Voipio <riku.voipio@linaro.org>
Reported-by: Doug Smythies <dsmythies@telus.net>
Tested-by: Doug Smythies <dsmythies@telus.net>
Tested-by: Kalle Valo <kvalo@codeaurora.org>
Acked-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Michal Marek <mmarek@suse.cz>
Cc: maximilian attems <maks@stro.at>
Cc: Chris J Arges <chris.j.arges@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/package/builddeb |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/package/builddeb~builddeb-remove-debian-files-before-build scripts/package/builddeb
--- a/scripts/package/builddeb~builddeb-remove-debian-files-before-build
+++ a/scripts/package/builddeb
@@ -115,7 +115,7 @@ esac
 BUILD_DEBUG="$(grep -s '^CONFIG_DEBUG_INFO=y' $KCONFIG_CONFIG || true)"
 
 # Setup the directory structure
-rm -rf "$tmpdir" "$fwdir" "$kernel_headers_dir" "$libc_headers_dir" "$dbg_dir"
+rm -rf "$tmpdir" "$fwdir" "$kernel_headers_dir" "$libc_headers_dir" "$dbg_dir" $objtree/debian/files
 mkdir -m 755 -p "$tmpdir/DEBIAN"
 mkdir -p "$tmpdir/lib" "$tmpdir/boot"
 mkdir -p "$fwdir/lib/firmware/$version/"
@@ -408,7 +408,7 @@ binary-arch:
 	\$(MAKE) KDEB_SOURCENAME=${sourcename} KDEB_PKGVERSION=${packageversion} bindeb-pkg
 
 clean:
-	rm -rf debian/*tmp
+	rm -rf debian/*tmp debian/files
 	mv debian/ debian.backup # debian/ might be cleaned away
 	\$(MAKE) clean
 	mv debian.backup debian
_

Patches currently in -mm which might be from riku.voipio@linaro.org are

builddeb-remove-debian-files-before-build.patch

