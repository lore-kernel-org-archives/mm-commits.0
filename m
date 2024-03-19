Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3483FB9F
	for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2024 21:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710884360; cv=none; b=AZYe3DrvWiGxRBa2MOXQlCL14s659YFSY/aJy+lYfe2zXXpujb6YiIfek5CxShSNiTBchvdqLjBOjtPGP1tDMxqON/s8iS+wMbn/+m2RFM48B7DQOLxvlJ15aQMy4P2ksOh4W4jPOAmVcJ/OIvu04qUbLxiN76M0TdTjEYPqG3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710884360; c=relaxed/simple;
	bh=Huyn9JP6VGv7+4T5o23G8PEyYHSkPy57MGmvv4SZhmw=;
	h=Date:To:From:Subject:Message-Id; b=Jy0RB1JZcYOcQUZ6p0vuF8oiY1dxxWC4+t0Cf3vx6T18EQkTpmBS0U/GxIIrvgHZqUoqU3AqmKjBs9e7Ma54BvF14/jaic8+JUm5CGQ2IxiczcCZf5poTx0vpAWF2zq+L4Ja7nrPybJwV10w7JcgKHhd8K3f3UQxwaN6ZPJmYHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z+ei+4Vt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z+ei+4Vt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E67C433F1;
	Tue, 19 Mar 2024 21:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710884360;
	bh=Huyn9JP6VGv7+4T5o23G8PEyYHSkPy57MGmvv4SZhmw=;
	h=Date:To:From:Subject:From;
	b=z+ei+4VtThNrx9SA/2Le0UvFyl1VDqWr1hYJhz2AOG8JDjCg7et+S5nkDS+2FZzgo
	 NMzttCOPMQg8GcnHMm6QufsouD4eGH/NvJXD1v2pIGXZMACqnZXpszXctQmLuSGgFK
	 zA6mcm1LhMT6h+K6vlpzuJy4d34WJBKhI1QqJnG4=
Date: Tue, 19 Mar 2024 14:39:19 -0700
To: mm-commits@vger.kernel.org,nicolas@fjasle.eu,masahiroy@kernel.org,u.kleine-koenig@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-build_oid_registry-dont-mention-the-full-path-of-the-script-in-output.patch added to mm-nonmm-unstable branch
Message-Id: <20240319213919.E1E67C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/build_OID_registry: don't mention the full path of the script in output
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-build_oid_registry-dont-mention-the-full-path-of-the-script-in-output.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-build_oid_registry-dont-mention-the-full-path-of-the-script-in-output.patch

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
From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Subject: lib/build_OID_registry: don't mention the full path of the script in output
Date: Wed, 13 Mar 2024 22:19:56 +0100

This change strips the full path of the script generating
lib/oid_registry_data.c to just lib/build_OID_registry.  The motivation
for this change is Yocto emitting a build warning

	File /usr/src/debug/linux-lxatac/6.7-r0/lib/oid_registry_data.c in package linux-lxatac-src contains reference to TMPDIR [buildpaths]

So this change brings us one step closer to make the build result
reproducible independent of the build path.

Link: https://lkml.kernel.org/r/20240313211957.884561-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/build_OID_registry |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/lib/build_OID_registry~lib-build_oid_registry-dont-mention-the-full-path-of-the-script-in-output
+++ a/lib/build_OID_registry
@@ -8,6 +8,7 @@
 #
 
 use strict;
+use Cwd qw(abs_path);
 
 my @names = ();
 my @oids = ();
@@ -17,6 +18,8 @@ if ($#ARGV != 1) {
     exit(2);
 }
 
+my $abs_srctree = abs_path($ENV{'srctree'});
+
 #
 # Open the file to read from
 #
@@ -35,7 +38,7 @@ close IN_FILE || die;
 #
 open C_FILE, ">$ARGV[1]" or die;
 print C_FILE "/*\n";
-print C_FILE " * Automatically generated by ", $0, ".  Do not edit\n";
+print C_FILE " * Automatically generated by ", $0 =~ s#^\Q$abs_srctree/\E##r, ".  Do not edit\n";
 print C_FILE " */\n";
 
 #
_

Patches currently in -mm which might be from u.kleine-koenig@pengutronix.de are

lib-build_oid_registry-dont-mention-the-full-path-of-the-script-in-output.patch

