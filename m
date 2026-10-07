Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49FF22576E
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338637; cv=none; b=Z5e5ZEzBcB9GN258kut+Q/CYZNYKBBFJGpFVfOvu64sfe1OtHEuByQ6thUbuKpViWSYXnI1C/cKAhYGC2H2rVRf4dw6TrH4pGrjrt+5X+LQQHK81Oay54kifOIyNYTQg6rFGH6/D+1FKUbMV2IqRnck8eYG9Glv+vYYIYO9JnqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338637; c=relaxed/simple;
	bh=/ukoo6ibDbtAcADh34IXm5TNYXGSkuMup63QvyFR0V4=;
	h=Date:To:From:Subject:Message-Id; b=rFn/rELPkveXT77mNjYiFWdTUPV9oyKTYlUygnr49ezoQvSKvvBJt/pi36sfHKikopY5E0tWLXfBgkXKCvpgfbpnBvU991ets57+77USKfgHQWWi3r37sFwyhFkZGNg9kiNItwnDFFDvIPrW769WM5eKfj5a3VtzacI8qHhp76Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=apZPtU8n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="apZPtU8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7D01F0089B;
	Wed,  7 Oct 2026 02:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338636;
	bh=OaeJPC5/NfTYS1UwOAjUnDVmwF7zHZBYBwvo99lzkcw=;
	h=Date:To:From:Subject;
	b=apZPtU8ns9b7Cfh5sZIJUU14PiQiIL2doFKXfF/n+v0+yWS3i3nY3Av+EIytd0qvD
	 XpL9NkIENMJCX9I2/wLKU4EJnH8Wwgf/5yoXFh9dwbbiiOYK0ZzCHFDMq3IcGRDi7L
	 6ue/vag6HWk27LaOIKxmKj9lUDQLWmZEZ+4TdEsI=
Date: Tue, 06 Oct 2026 19:03:55 -0700
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,pvorel@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-skip-camelcase-cache-for-no-tree-without-root.patch removed from -mm tree
Message-Id: <20261007020356.4B7D01F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: skip CamelCase cache for --no-tree without root
has been removed from the -mm tree.  Its filename was
     checkpatch-skip-camelcase-cache-for-no-tree-without-root.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Petr Vorel <pvorel@suse.cz>
Subject: checkpatch: skip CamelCase cache for --no-tree without root
Date: Mon, 10 Aug 2026 18:11:59 +0200

Running outside tree (--no-tree) without git root (--root DIR) is not
doable because we have no include/ directory which could be cached.  But
3445686af721 expected that we are always in Linux tree (w/a git).  But
--no-tree does not require --root.  Therefore skip whole caching in that
case.

This fixes perl and find errors when running checkpatch.pl *with*
--no-tree --strict and *without* --root:

    No structs that should be const will be found - file 'scripts/const_structs.checkpatch': No such file or directory
    Use of uninitialized value $root in concatenation (.) or string at scripts/checkpatch.pl line 1213.
    find: `/include': No such file or directory

Link: https://lore.kernel.org/20260810161159.1044160-1-pvorel@suse.cz
Fixes: 3445686af721 ("checkpatch: ignore existing CamelCase uses from include/...")
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---

 scripts/checkpatch.pl |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-skip-camelcase-cache-for-no-tree-without-root
+++ a/scripts/checkpatch.pl
@@ -1206,6 +1206,8 @@ sub seed_camelcase_includes {
 		my $git_last_include_commit = `${git_command} log --no-merges --pretty=format:"%h%n" -1 -- include`;
 		chomp $git_last_include_commit;
 		$camelcase_cache = ".checkpatch-camelcase.git.$git_last_include_commit";
+	} elsif (not defined $root) {
+		return;
 	} else {
 		my $last_mod_date = 0;
 		$files = `find $root/include -name "*.h"`;
_

Patches currently in -mm which might be from pvorel@suse.cz are


