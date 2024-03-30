Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEEC1878
	for <mm-commits@vger.kernel.org>; Sat, 30 Mar 2024 02:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711767539; cv=none; b=l9n+amkTcLvIGYWmR2cbx1HOoq3SJR8ZGvjVuw2O7pJaTKXqWpofgiGagt+qmzrc6gMTaiyO495RQc5fClm7rU12HyVVUUbbW3kX5uS/AsrctFRk19ecEJQN69FXeAco64YB6xuLOv2AgTTURzgDeLkzq+Ueb7jGn5lvRE+FeEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711767539; c=relaxed/simple;
	bh=gDpMWoCGLF7DsRt8Nlp8cNE2JiYfTTmHs1ueSu+iQPU=;
	h=Date:To:From:Subject:Message-Id; b=awuEHauixEZnheIdFlQ46w3sJCDQJdykG43DgcZ9QHydvJjr1o96QtIPuN7bUceJownu04gziV3bgAxfnoHKUuzB2gEsCSAJaZyc/D3F4CQ0IL52VPDW+fC6LrL0Jr0ANTfPezV4Ky4AOiVosc7LUDB9YdPVBYCtKfRtfdxPmjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eZ5Y/ln7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eZ5Y/ln7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A89C433C7;
	Sat, 30 Mar 2024 02:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711767539;
	bh=gDpMWoCGLF7DsRt8Nlp8cNE2JiYfTTmHs1ueSu+iQPU=;
	h=Date:To:From:Subject:From;
	b=eZ5Y/ln75WCtvn6oJ1puVNCi3wUn95LCXHFp9JymnbdCQpDOzLiWGsP02/i1MY5j4
	 aqV49wFbB0Jsd4ZPphJNthuOIGdwDognhrqLODWannObJrpd22V1/dKAGbi0JkvyJA
	 eGq1Efe2wbJRvcvdvL/8SbayD7CVA6NFMUVn4umo=
Date: Fri, 29 Mar 2024 19:58:58 -0700
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,sfr@canb.auug.org.au,lukas.bulwahn@gmail.com,linux@roeck-us.net,joe@perches.com,jcmvbkbc@gmail.com,herbert@gondor.apana.org.au,dwaipayanray1@gmail.com,corbet@lwn.net,chris@zankel.net,chenhuacai@loongson.cn,broonie@kernel.org,apw@canonical.com,ma.xxn@outlook.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] scripts-checkpatch-check-unused-parameters-for-function-like-macro.patch removed from -mm tree
Message-Id: <20240330025859.19A89C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts: checkpatch: check unused parameters for function-like macro
has been removed from the -mm tree.  Its filename was
     scripts-checkpatch-check-unused-parameters-for-function-like-macro.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Xining Xu <ma.xxn@outlook.com>
Subject: scripts: checkpatch: check unused parameters for function-like macro
Date: Fri, 22 Mar 2024 21:49:37 +1300

If function-like macros do not utilize a parameter, it might result in a
build warning.  In our coding style guidelines, we advocate for utilizing
static inline functions to replace such macros.  This patch verifies
compliance with the new rule.

For a macro such as the one below,

 #define test(a) do { } while (0)

The test result is as follows.

 ERROR: Parameter 'a' is not used in function-like macro, please use static
 inline instead
 #21: FILE: mm/init-mm.c:20:
 +#define test(a) do { } while (0)

 total: 1 errors, 0 warnings, 8 lines checked

Link: https://lkml.kernel.org/r/20240322084937.66018-3-21cnbao@gmail.com
Signed-off-by: Xining Xu <ma.xxn@outlook.com>

Tested-by: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Huacai Chen <chenhuacai@loongson.cn>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mark Brown <broonie@kernel.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/scripts/checkpatch.pl~scripts-checkpatch-check-unused-parameters-for-function-like-macro
+++ a/scripts/checkpatch.pl
@@ -6109,6 +6109,30 @@ sub process {
 				WARN("TRAILING_SEMICOLON",
 				     "macros should not use a trailing semicolon\n" . "$herectx");
 			}
+
+			if ($dstat =~ /^\+\s*#\s*define\s+$Ident\s*(\((?:[^\(\)]++|(?-1))*\))\s+(\S+.*)(\/\/.*)?/) {
+				my $params = $1 || "";
+				my $body = $2 || "";
+
+			    # get the individual params
+				$params =~ tr/()//d;
+				# remove leading and trailing whitespace
+				$params =~ s/^\s+|\s+$//g;
+
+				$ctx =~ s/\n*$//;
+				my $cnt = statement_rawlines($ctx);
+				my $herectx = get_stat_here($linenr, $cnt, $here);
+
+				if ($params ne "") {
+					my @paramList = split /,\s*/, $params;
+					foreach my $param(@paramList) {
+						if ($body !~ /\b$param\b/) {
+							ERROR("UNUSED_PARAM_IN_MACRO",
+							     "Parameter '$param' is not used in function-like macro, please use static inline instead\n" . "$herectx");
+						}
+					}
+				}
+			}
 		}
 
 # check for redundant bracing round if etc
_

Patches currently in -mm which might be from ma.xxn@outlook.com are


