Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBBA371D0F
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028756; cv=none; b=d2ePZ4DczISeWE4K/AkOYFgPab5iOXGvTID/6rUxynVdcJfybp2KwJWSkTAO3BIyAMQSTdTyhzE9J34KYxMRVA8HnWYPphAFVIl6ORvNZ9hAJF4O3XDCWXmh0RKLBmrzEvxQeHCdy8//ge0LAFg0FpZv/UHJzOCRhREorRtzbIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028756; c=relaxed/simple;
	bh=pHzZm2Gs04g3FIdBXZbXSYfdH2xhDJSckOo0CEpweb8=;
	h=Date:To:From:Subject:Message-Id; b=J6Cci2ZymlLeVYWIjjnX0GQu2/Gr0eV46R66XQgz0fMyDylBQY3rbfzIWXxmhWOqkjXCOH+wEpVbNsiDlSWs7l9ZKoT0n61fvrIFixXwxjWZNWQ1HcBUHkL+Dw1sPlOgT2bwv4wDhqSoL927C1uNnbJpf42MGRcz5YsSSkYPsPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uUEvwfWw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uUEvwfWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2601F00898;
	Fri, 29 May 2026 04:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028755;
	bh=ckVACUFCOweiN8wS8rsoJFvFND1wsIviLGfxPBTEdLs=;
	h=Date:To:From:Subject;
	b=uUEvwfWwqsKUFhoJV6r8dVeT3jpbS8TsX4/qSisbJKzjUQXadYQRb6tea0gl8IAFw
	 ZViUlJlt/K35eHPc+PdLdTZ6+ep9+CC0RcZIIe1PZPE1jLuT4+Eu2765MKmxgIr0ra
	 i8X9S2Pn1qU5G7dvpT6Ai3Ls2epppDZPfdj/l4v4=
Date: Thu, 28 May 2026 21:25:55 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,jlayton@kernel.org,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kselftest-filelock-add-a-gitignore-file.patch removed from -mm tree
Message-Id: <20260529042555.8D2601F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kselftest/filelock: add a .gitignore file
has been removed from the -mm tree.  Its filename was
     kselftest-filelock-add-a-gitignore-file.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: kselftest/filelock: add a .gitignore file
Date: Thu, 26 Feb 2026 16:05:27 +0000

Tell git to ignore the generated binary for the test.

Link: https://lore.kernel.org/20260226-selftest-filelock-ktap-v4-3-db8ae192ff42@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/filelock/.gitignore |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/filelock/.gitignore a/tools/testing/selftests/filelock/.gitignore
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/filelock/.gitignore
@@ -0,0 +1 @@
+ofdlocks
_

Patches currently in -mm which might be from broonie@kernel.org are


