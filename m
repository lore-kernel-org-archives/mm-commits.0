Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD0CDF71
	for <mm-commits@vger.kernel.org>; Sat, 24 Aug 2024 05:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724478965; cv=none; b=KWMidGQaIMpQuy5UBtmK/UNB2lX4Pc16fbtKz6kQUYmohG+MvZ4IA02+R4Z/9N4OFtsI27X4uw6TPZKrHFcZKIcdJw71p3aFGktWetQdwAA/WLyIiN4rhtRskGFuJDCSuoG1SdN10rFxglWbFMxi8g7yXqsUYx3tRCXSxpsioj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724478965; c=relaxed/simple;
	bh=1zsuOD27NKb0XTlA/YQ/eJ986nx0wpNBync/ajbJ2vM=;
	h=Date:To:From:Subject:Message-Id; b=Lj3ZenkJmu66HiMgvLX16NFZ6mJ5bNxP+TGbuJ94dBZbugpgKqQeuduBANgJdNcyHDXwUzaznJAEfBwkLZSzXyPDY5kKn0At7fg1GGTMxn97FZOT6sDxQpABj0Ln+eeOZySu+AfAAKZZH4kLJPtlUjXpGYxZy30cTeqaYvjHtqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WUUMK4JM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WUUMK4JM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37E5C32781;
	Sat, 24 Aug 2024 05:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724478964;
	bh=1zsuOD27NKb0XTlA/YQ/eJ986nx0wpNBync/ajbJ2vM=;
	h=Date:To:From:Subject:From;
	b=WUUMK4JMOgUIF20jY+8mKZJHibXLWCHo1MJyrDVg8SFKRq3O15ZaoBVizLXlrP7kT
	 Qo0jEbKaABd6qkZTQuNastJnvupn2I8UunImGP5APXc7d2oWZ4lMl768lGqsFXI0yK
	 Inlr/MHSvTxKoa2meMT21KWiv6bJfuuZmMQK2n4E=
Date: Fri, 23 Aug 2024 22:56:04 -0700
To: mm-commits@vger.kernel.org,thomas.petazzoni@bootlin.com,swboyd@chromium.org,sashal@kernel.org,koct9i@gmail.com,alexis.lothore@bootlin.com,luca.ceresoli@bootlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-decode_stacktracesh-add-h-flag.patch added to mm-nonmm-unstable branch
Message-Id: <20240824055604.B37E5C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/decode_stacktrace.sh: add '-h' flag
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-decode_stacktracesh-add-h-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-decode_stacktracesh-add-h-flag.patch

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
From: Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: scripts/decode_stacktrace.sh: add '-h' flag
Date: Fri, 23 Aug 2024 10:27:44 +0200

When no parameters are passed, the usage instructions are presented only
when debuginfod-find is not found.  This makes sense because with
debuginfod none of the positional parameters are needed.  However it means
that users having debuginfod-find installed will have no chance of reading
the usage text without opening the file.

Many programs have a '-h' flag to get the usage, so add such a flag. 
Invoking 'scripts/decode_stacktrace.sh -h' will now show the usage text
and exit.

Link: https://lkml.kernel.org/r/20240823-decode_stacktrace-find_module-improvements-v2-3-d7a57d35558b@bootlin.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Cc: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktracesh-add-h-flag
+++ a/scripts/decode_stacktrace.sh
@@ -7,6 +7,7 @@ usage() {
 	echo "Usage:"
 	echo "	$0 -r <release>"
 	echo "	$0 [<vmlinux> [<base_path>|auto [<modules_path>]]]"
+	echo "	$0 -h"
 }
 
 # Try to find a Rust demangler
@@ -33,7 +34,10 @@ READELF=${UTIL_PREFIX}readelf${UTIL_SUFF
 ADDR2LINE=${UTIL_PREFIX}addr2line${UTIL_SUFFIX}
 NM=${UTIL_PREFIX}nm${UTIL_SUFFIX}
 
-if [[ $1 == "-r" ]] ; then
+if [[ $1 == "-h" ]] ; then
+	usage
+	exit 0
+elif [[ $1 == "-r" ]] ; then
 	vmlinux=""
 	basepath="auto"
 	modpath=""
_

Patches currently in -mm which might be from luca.ceresoli@bootlin.com are

scripts-decode_stacktracesh-remove-find_module-recursion-and-improve-error-reporting.patch
scripts-decode_stacktracesh-clarify-command-line.patch
scripts-decode_stacktracesh-add-h-flag.patch

