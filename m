Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00072152E02
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248845; cv=none; b=PUn4+gl+9teOfYZoKlHMBq0eBAG0e9BduYuacoUucliQsEZgtBCpAzQQw8IDdNLIXA8qHJoRFVOf+ULxS/XdDUnQAXRxcZQVhAXSHo2qPzIh2AExyKM6lprtSsbNB1vvSXQX23GClJNVoC2KHOdokSPzI6gq2OdXofmm93UdWJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248845; c=relaxed/simple;
	bh=Vq1nScSWx5rIDRmw5RMzKAj/yOHGl0qsSP7Yy4e6CQQ=;
	h=Date:To:From:Subject:Message-Id; b=OP2fqDZDYpF7clniaeDPV0ehqKMR0N4vdSgDMVRTLPDdFnKgZm7lOTwc0mx0ydfPN05PDv5cjuqc1KwqkRjxboJvIijt1zVSSGrXNWGxOGiKYrRC0RuCQG8fNqWPrCewClWdTT6I4wAEVbk74NSkqlNrPEst5kLXskWLlqEJKeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AwrqToKF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AwrqToKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F9FC4CEC2;
	Mon,  2 Sep 2024 03:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248844;
	bh=Vq1nScSWx5rIDRmw5RMzKAj/yOHGl0qsSP7Yy4e6CQQ=;
	h=Date:To:From:Subject:From;
	b=AwrqToKFDHMzvukVW7uxHn3fZJQZWl5iZrIxhtx/Bi/iYKHPY9MPkvgBCD5zGfl1S
	 dalu91EcofrWdDH5JDWbfpkf0tW9ymYtmNEVowIVS0ufYwsWGaWWvsIPM0bshigoZx
	 VCdoEzA/UkJPOIAXgXm4RCxGusPEMcG3hV1eSMb0=
Date: Sun, 01 Sep 2024 20:47:24 -0700
To: mm-commits@vger.kernel.org,thomas.petazzoni@bootlin.com,swboyd@chromium.org,sashal@kernel.org,koct9i@gmail.com,alexis.lothore@bootlin.com,luca.ceresoli@bootlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-decode_stacktracesh-clarify-command-line.patch removed from -mm tree
Message-Id: <20240902034724.C2F9FC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/decode_stacktrace.sh: clarify command line
has been removed from the -mm tree.  Its filename was
     scripts-decode_stacktracesh-clarify-command-line.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: scripts/decode_stacktrace.sh: clarify command line
Date: Fri, 23 Aug 2024 10:27:43 +0200

The syntax as expressed by usage() is not entirely correct: "<modules
path>" cannot be passed without "<base path>|auto".  Additionally human
reading of this syntax can be subject to misunderstanding due the mixture
of '|' and '[]'.

Improve readability in various ways:
 * rewrite using two lines for the two allowed usages
 * add square brackets around "<vmlinux>" as it is optional when using
   debuginfod-find
 * move "<modules path>" to inside the square brackets of the 2nd
   positional parameter
 * use underscores instead of spaces in <...> strings

Link: https://lkml.kernel.org/r/20240823-decode_stacktrace-find_module-improvements-v2-2-d7a57d35558b@bootlin.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Cc: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktracesh-clarify-command-line
+++ a/scripts/decode_stacktrace.sh
@@ -5,7 +5,8 @@
 
 usage() {
 	echo "Usage:"
-	echo "	$0 -r <release> | <vmlinux> [<base path>|auto] [<modules path>]"
+	echo "	$0 -r <release>"
+	echo "	$0 [<vmlinux> [<base_path>|auto [<modules_path>]]]"
 }
 
 # Try to find a Rust demangler
_

Patches currently in -mm which might be from luca.ceresoli@bootlin.com are


