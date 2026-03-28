Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019F41A9FA8
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671952; cv=none; b=SKqlinTocWnK8zYVZ7ru18cX8hiMj4cdoak+X+9Nyvzlg1zfv/7yXMvJFDL3zhTGXWrTnrmVxPL9IqosMxZUlTFKJwFmDlg9+OidZym905BL/jPhlObB2g7ONs+x3P+jsUfhop4U13DkCCfWkW5nlALRC6VVIxJfSv2wG4/XqYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671952; c=relaxed/simple;
	bh=M1Sz0qdSSPOTyVHur/qojF54ovIphTAthIr4LBWLWZw=;
	h=Date:To:From:Subject:Message-Id; b=X9joiiNwdsDmORJmUNeSsrciZo/ar6cXdUPkkWTp7QoKfBssD8DE8csNf591skzNKjqRb62ixyH8sIVqrbcXd65myTB7h7Qbk3FWbHJ7eLTXVqaYuhtWRUfABVZyuux1CupJxsWvih88CuMO3rtqns7L/9kNYIwxr9+LV4nVJ9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WvMLVc6l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WvMLVc6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E6FC4CEF7;
	Sat, 28 Mar 2026 04:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671951;
	bh=M1Sz0qdSSPOTyVHur/qojF54ovIphTAthIr4LBWLWZw=;
	h=Date:To:From:Subject:From;
	b=WvMLVc6lL1jIf496Fh+KXS0eWVfmVpeqUfW+OvjDpfxXmndMhkj9gb81R3OeHyJVL
	 /wdxgM/Qdcv3q7N4eh8aT/NXWtrLgKYEW+UcC7g55lTzPAlf/jLf1Y/odZVTkns7OT
	 POTVcUFwwXAAxHtf1bt6XZUbn7XRUEvsw57jt76k=
Date: Fri, 27 Mar 2026 21:25:51 -0700
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,corbet@lwn.net,bvanassche@acm.org,apw@canonical.com,sashal@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-add-support-for-assisted-by-tag.patch removed from -mm tree
Message-Id: <20260328042551.92E6FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: add support for Assisted-by tag
has been removed from the -mm tree.  Its filename was
     checkpatch-add-support-for-assisted-by-tag.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

kallsyms-embed-source-file-line-info-in-kernel-stack-traces.patch
kallsyms-extend-lineinfo-to-loadable-modules.patch
kallsyms-delta-compress-lineinfo-tables-for-27x-size-reduction.patch
kallsyms-add-kunit-tests-for-lineinfo-feature.patch

