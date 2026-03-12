Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3957EDDCD
	for <mm-commits@vger.kernel.org>; Thu, 12 Mar 2026 21:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773351464; cv=none; b=lGufMG4P0pLGwdJRc6p8yb4NIcLRCyNf2w8YHDaavfL+CEcozmMCg5g89hYSBdcMNNoMv6Pr7A7LBAi1d2huntwJk8v+6afW/6pRRH9+ZMLeISD+tGu2ORhJ15/V0Wefp2BLfKIzzhJfsryscHJssSYc6MGf8ULblco8QmNbJE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773351464; c=relaxed/simple;
	bh=VSsppNNOQXT6zkJI1YyIBNDF9EJi8uymE+GW5CZEOWA=;
	h=Date:To:From:Subject:Message-Id; b=Zqa3HkoYN87nR924GlErcrKIcJXvyTwVwnPmAao4cbu6MHQkBgsVzezws2dS5bMb/np2k0V3uMZOPerh2p/ZT3bPNubuz882o7CB0+4goqvtmhaalfbUDDNW+OvwBpW8kZptWyAD0zLby5lK8RdJdIfXNSh+ffqGmxT7zWAx6d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gW1LgNoq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gW1LgNoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0985C4CEF7;
	Thu, 12 Mar 2026 21:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773351463;
	bh=VSsppNNOQXT6zkJI1YyIBNDF9EJi8uymE+GW5CZEOWA=;
	h=Date:To:From:Subject:From;
	b=gW1LgNoq+TmpKT/gNNoZ90oyb1Dq4af+QLs5O7ClD2gnL3FT4V5iCdbWIwFohXP31
	 IhAx2f2Rsd7sL7md9CSRfgn0Myle2SuD3i4vZgkZn3ZGQjJUiPsfNx80A9GveP7oP8
	 D7TH4H/XSaTiEQ2Jl0YwA+nmcJ1nzForNFhiSg+A=
Date: Thu, 12 Mar 2026 14:37:43 -0700
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,corbet@lwn.net,bvanassche@acm.org,apw@canonical.com,sashal@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-add-support-for-assisted-by-tag.patch added to mm-nonmm-unstable branch
Message-Id: <20260312213743.B0985C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: add support for Assisted-by tag
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-add-support-for-assisted-by-tag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-add-support-for-assisted-by-tag.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sasha Levin <sashal@kernel.org>
Subject: checkpatch: add support for Assisted-by tag
Date: Wed, 11 Mar 2026 17:58:17 -0400

The Assisted-by tag was introduced in
Documentation/process/coding-assistants.rst for attributing AI tool
contributions to kernel patches.  However, checkpatch.pl did not recognize
this tag, causing two issues:

  WARNING: Non-standard signature: Assisted-by:
  ERROR: Unrecognized email address: 'AGENT_NAME:MODEL_VERSION'

Fix this by:
1. Adding Assisted-by to the recognized $signature_tags list
2. Skipping email validation for Assisted-by lines since they use the
   AGENT_NAME:MODEL_VERSION format instead of an email address
3. Warning when the Assisted-by value doesn't match the expected format

Link: https://lkml.kernel.org/r/20260311215818.518930-1-sashal@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Reported-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-add-support-for-assisted-by-tag
+++ a/scripts/checkpatch.pl
@@ -641,6 +641,7 @@ our $signature_tags = qr{(?xi:
 	Reviewed-by:|
 	Reported-by:|
 	Suggested-by:|
+	Assisted-by:|
 	To:|
 	Cc:
 )};
@@ -3105,6 +3106,15 @@ sub process {
 				}
 			}
 
+			# Assisted-by uses AGENT_NAME:MODEL_VERSION format, not email
+			if ($sign_off =~ /^Assisted-by:/i) {
+				if ($email !~ /^\S+:\S+/) {
+					WARN("BAD_SIGN_OFF",
+					     "Assisted-by expects 'AGENT_NAME:MODEL_VERSION [TOOL1] [TOOL2]' format\n" . $herecurr);
+				}
+				next;
+			}
+
 			my ($email_name, $name_comment, $email_address, $comment) = parse_email($email);
 			my $suggested_email = format_email(($email_name, $name_comment, $email_address, $comment));
 			if ($suggested_email eq "") {
_

Patches currently in -mm which might be from sashal@kernel.org are

checkpatch-add-support-for-assisted-by-tag.patch

