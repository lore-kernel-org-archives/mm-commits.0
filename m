Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9F013C3F7
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720291231; cv=none; b=R9tmaDq+9bUncpKANJwpdPwMc88YzDhuNSiTHuZfiPGz7r/iuMZCccPU1kMSadvDq0SfOTtnpLL7XBYYQUctl7D1/3MtzCKUyA6dnAprW/10XybgYPSvx9dpyWRc39bSrM/Kj2tVad674UP0gSvPDhsDEf6ePv9ALdej1+oTdb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720291231; c=relaxed/simple;
	bh=mmoKniQLOt+FRdmKWRHwBQCX3QnYcA+wjcjDtszKrio=;
	h=Date:To:From:Subject:Message-Id; b=fqIlOMAhqr+VhWZdg6+F+TG/iYrfUoCX76rZ1vbZV+oWXI4kqFNP27HjNB8HmRvChSbjF+6OTimZuKn30NGjw6KpNF6kMwmMoui/jkOJFo1hiXjMea7uGsEqTQgGr+00usBu5bM3o1nWjpStmPJA1kxrlk+KZLh15drYXx2K8gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dydggx4F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dydggx4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBC8C32781;
	Sat,  6 Jul 2024 18:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720291230;
	bh=mmoKniQLOt+FRdmKWRHwBQCX3QnYcA+wjcjDtszKrio=;
	h=Date:To:From:Subject:From;
	b=dydggx4F2FOvbioVrYQQLrluh1kN0pWTeSQeuFSZ16ZDFfA4zb9sBVsEz0NMqHLMO
	 UGyWSsQ3pWsJnuLhh5gcbgHpZl+iozqGw67OHZtX6qFLkGgSsPvV4RxJjzbFtG5cmK
	 k96PyfzEyqsO42fj/Ciz6RwElnqiuu+Ua6fyUZYI=
Date: Sat, 06 Jul 2024 11:40:29 -0700
To: mm-commits@vger.kernel.org,u.kleine-koenig@pengutronix.de,nicolas@fjasle.eu,masahiroy@kernel.org,a.fatoum@pengutronix.de,pmenzel@molgen.mpg.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-build_oid_registry-avoid-non-destructive-substitution-for-perl-5132-compat.patch removed from -mm tree
Message-Id: <20240706184030.7DBC8C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/build_OID_registry: avoid non-destructive substitution for Perl < 5.13.2 compat
has been removed from the -mm tree.  Its filename was
     lib-build_oid_registry-avoid-non-destructive-substitution-for-perl-5132-compat.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lkml.kernel.org/r/20240702223512.8329-2-pmenzel@molgen.mpg.de
Link: https://lkml.kernel.org/r/20240701155802.75152-1-pmenzel@molgen.mpg.de
Fixes: 5ef6dc08cfde ("lib/build_OID_registry: don't mention the full path of the script in output")
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


