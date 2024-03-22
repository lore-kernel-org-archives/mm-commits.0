Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772BC762FC
	for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2024 19:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711134420; cv=none; b=YRxA6Yrmav03MDCdHD9os+Y1dJBpQSQ0BB1Hyh9JfQUUTPfYFQy0heIVQL/euhDdiUT4IwiIkqD8ESNwGU9Rwc2BbhmWvKHK0K3vgt9IHrP80h+YFPn7bZ19ZdYZv3BUcGV0uedEA6Ius6gYBFmtqDmB4eMSN1p8+W8dT1AJ7Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711134420; c=relaxed/simple;
	bh=jxdzlnQMYV57xLyHVKlbqp8kFobvLLOkkSMw5x4wBUQ=;
	h=Date:To:From:Subject:Message-Id; b=CVsIAs4cbeodtr3v1etJNMxTObPsdOwXbRSvAgRSO16DfpCrquVmxOHyASzmVFQkKLhHhRmDdJ0hybGw5n8c1bnQZgUZeE3vsJjePb8EvqLIgDV2T5G0N3ZzxTT/wy2HV/2Iuad43wDown+QBYb/vQMi2HaQyUBFHMhZEMvT47U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yyg/MvhC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yyg/MvhC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A0EC433C7;
	Fri, 22 Mar 2024 19:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711134420;
	bh=jxdzlnQMYV57xLyHVKlbqp8kFobvLLOkkSMw5x4wBUQ=;
	h=Date:To:From:Subject:From;
	b=yyg/MvhCRG+E+IowBr+RYrmVDnqnsT+SyEtC1AbfWBLA1+9UdE7JYCmGzOI6EGSM+
	 SUqnHt8DfR20T5wkMcJcAk+bTSTfreuqVhMVFHu3EDEdEEahQnk/pWOj5qHwHPlHIA
	 Iw7nh7iNOCCIfgjnSeAFZsodCAyArxGZCjV4fgHU=
Date: Fri, 22 Mar 2024 12:06:59 -0700
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,sfr@canb.auug.org.au,lukas.bulwahn@gmail.com,linux@roeck-us.net,joe@perches.com,jcmvbkbc@gmail.com,herbert@gondor.apana.org.au,dwaipayanray1@gmail.com,corbet@lwn.net,chris@zankel.net,chenhuacai@loongson.cn,broonie@kernel.org,apw@canonical.com,ma.xxn@outlook.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-checkpatch-check-unused-parameters-for-function-like-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20240322190659.E6A0EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts: checkpatch: check unused parameters for function-like macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-checkpatch-check-unused-parameters-for-function-like-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-checkpatch-check-unused-parameters-for-function-like-macro.patch

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

scripts-checkpatch-check-unused-parameters-for-function-like-macro.patch

