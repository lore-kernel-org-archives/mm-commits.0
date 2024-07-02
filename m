Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD6F101E4
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 02:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719887872; cv=none; b=Ualt8y4UTL8x8LNmzugdh5/auS8LKcf4z7bIeAyhuerrsH9TnRhkbHq1xKj+68+b+sShzCAzoS/452n4tHSCJmuKXisIcC7GlDJ4LGhkVHe5kiRDFni5dZfPNSasXW7/yrTQ4YXgPTq/UuNhYYpUyCs2CDHSCiDpOKfnX+nArcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719887872; c=relaxed/simple;
	bh=xLfs1Q0ZU9nRDXaY465fSA/kBWVoaBngFB+ayKuEbCI=;
	h=Date:To:From:Subject:Message-Id; b=u5oKU18ymDaB6Hlp1YqNmaP567IMcbln46tPb3WmWabGdFiYrxnAB4FTXM2qw4+zRD5+BNiZ9y8bbz7M5Lcc+oxvhmIEqWvr2FBhovnrZ6PymT9Mzyl0hV7UEhgsuTtf5Q5zB4vEr0et66g7++KsYaduGO21w65LTMR5Rqu/CRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b7KtTsCz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b7KtTsCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77680C116B1;
	Tue,  2 Jul 2024 02:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719887872;
	bh=xLfs1Q0ZU9nRDXaY465fSA/kBWVoaBngFB+ayKuEbCI=;
	h=Date:To:From:Subject:From;
	b=b7KtTsCzGbK1klyJddkcuJR1h8WFm6EsbnVWdhiL7EvUU9+nbqR47FP2VUoO8QrYq
	 0JOj5kPSAU20VDsm6E5Vevr9hOVwoQmFT5HdLrFyI8hCspwqc5FSh8etVxBJwjW9Ki
	 +uLuSJxpon7W/3iX4mG3NLwE6W7pORPnLtzLW1Xk=
Date: Mon, 01 Jul 2024 19:37:51 -0700
To: mm-commits@vger.kernel.org,u.kleine-koenig@pengutronix.de,nicolas@fjasle.eu,masahiroy@kernel.org,a.fatoum@pengutronix.de,pmenzel@molgen.mpg.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-build_oid_registry-avoid-non-destructive-substitution-for-perl-5132-compat.patch added to mm-hotfixes-unstable branch
Message-Id: <20240702023752.77680C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/build_OID_registry: avoid non-destructive substitution for Perl < 5.13.2 compat
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-build_oid_registry-avoid-non-destructive-substitution-for-perl-5132-compat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-build_oid_registry-avoid-non-destructive-substitution-for-perl-5132-compat.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: lib/build_OID_registry: avoid non-destructive substitution for Perl < 5.13.2 compat
Date: Mon, 1 Jul 2024 17:58:01 +0200

On a system with Perl 5.12.1, commit 5ef6dc08cfde
("lib/build_OID_registry: don't mention the full path of the script in
output") causes the build to fail with the error below.

     Bareword found where operator expected at ./lib/build_OID_registry line 41, near "s#^\Q$abs_srctree/\E##r"
     syntax error at ./lib/build_OID_registry line 41, near "s#^\Q$abs_srctree/\E##r"
     Execution of ./lib/build_OID_registry aborted due to compilation errors.
     make[3]: *** [lib/Makefile:352: lib/oid_registry_data.c] Error 255

Ahmad Fatoum analyzed that non-destructive substitution is only supported since
Perl 5.13.2. Instead of dropping `r` and having the side effect of modifying
`$0`, introduce a dedicated variable to support older Perl versions.

Link: https://lkml.kernel.org/r/20240701155802.75152-1-pmenzel@molgen.mpg.de
Fixes: 5ef6dc08cfde ("lib/build_OID_registry: don't mention the full path of
the script in output")
Link: https://lore.kernel.org/all/259f7a87-2692-480e-9073-1c1c35b52f67@molgen.mpg.de/
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Suggested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/build_OID_registry |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/lib/build_OID_registry~lib-build_oid_registry-avoid-non-destructive-substitution-for-perl-5132-compat
+++ a/lib/build_OID_registry
@@ -38,7 +38,9 @@ close IN_FILE || die;
 #
 open C_FILE, ">$ARGV[1]" or die;
 print C_FILE "/*\n";
-print C_FILE " * Automatically generated by ", $0 =~ s#^\Q$abs_srctree/\E##r, ".  Do not edit\n";
+my $scriptname = $0;
+$scriptname =~ s#^\Q$abs_srctree/\E##;
+print C_FILE " * Automatically generated by ", $scriptname, ".  Do not edit\n";
 print C_FILE " */\n";
 
 #
_

Patches currently in -mm which might be from pmenzel@molgen.mpg.de are

lib-build_oid_registry-avoid-non-destructive-substitution-for-perl-5132-compat.patch

