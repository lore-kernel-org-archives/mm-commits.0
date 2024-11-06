Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683AF17F4F6
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855628; cv=none; b=GRIeOhRXzLypli3qcAf0m63+rtm4kpB2loXCc9UGCaCNoEADNKxjs/dcSLXbivTKWOzhUlPnb5c99fzbGXNnBX7xfMWEO/wtrfoznMEtTspsfQTIVHhz7M+kIENUpsFhpKjgRZDnKWG/kL/wgN7HRovVOjuvirLZadS21MW1NXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855628; c=relaxed/simple;
	bh=Qng9aPrLYct5rmAKpjGXOMf1MTp4XFtSQ/c8pq+K4ls=;
	h=Date:To:From:Subject:Message-Id; b=ppqR6ncHm0mgc8hmBVvSShzo0illA85R0BV083s2v2H+5Cg9uBiSgC+gOGNDtfEulycKiYh9l6fWIxclyCETdY+MVbqXTaRFWfkcMH/GgcGewjKF4QBrH1hCeOvo4UuzXy+DENKEDbp4GVvAyrLxgwa1r6qKualZ30+qdM8ihcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o9bX0l9t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o9bX0l9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40479C4CECF;
	Wed,  6 Nov 2024 01:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855628;
	bh=Qng9aPrLYct5rmAKpjGXOMf1MTp4XFtSQ/c8pq+K4ls=;
	h=Date:To:From:Subject:From;
	b=o9bX0l9to2I0+Pw2URrGXxubH2cZ+jPMh5mJnZHbQ/4vSXJi5KrrfnwoVp6UM1Zu8
	 EiDCD8U/RU6u7XFJg/VMz93xlldWUAtwuTwtiYgxpdkp3i7ont1usO7fN/4+aAQbip
	 ZPBmx8Jgb1SyQ3avNytTK6xKZylYacFM7T8Dlpn0=
Date: Tue, 05 Nov 2024 17:13:47 -0800
To: mm-commits@vger.kernel.org,xndchn@gmail.com,swboyd@chromium.org,quic_eberman@quicinc.com,quic_bjorande@quicinc.com,luca.ceresoli@bootlin.com,cmllamas@google.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-decode_stacktracesh-remove-trailing-space.patch removed from -mm tree
Message-Id: <20241106011348.40479C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/decode_stacktrace.sh: remove trailing space
has been removed from the -mm tree.  Its filename was
     scripts-decode_stacktracesh-remove-trailing-space.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: scripts/decode_stacktrace.sh: remove trailing space
Date: Mon, 14 Oct 2024 03:02:10 -0700

decode_stacktrace.sh adds a trailing space at the end of the decoded stack
if the module is not set (in most of the lines), which makes the some
lines of the stack having trailing space and some others not.

Do not add an extra space at the end of the line if module is not set,
adding consistency in output formatting.

Link: https://lkml.kernel.org/r/20241014100213.1873611-1-leitao@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Elliot Berman <quic_eberman@quicinc.com>
Reviewed-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Cc: Bjorn Andersson <quic_bjorande@quicinc.com>
Cc: Luca Ceresoli <luca.ceresoli@bootlin.com>
Cc: Xiong Nandi <xndchn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktracesh-remove-trailing-space
+++ a/scripts/decode_stacktrace.sh
@@ -311,7 +311,12 @@ handle_line() {
 	parse_symbol # modifies $symbol
 
 	# Add up the line number to the symbol
-	echo "${words[@]}" "$symbol $module"
+	if [[ -z ${module} ]]
+	then
+		echo "${words[@]}" "$symbol"
+	else
+		echo "${words[@]}" "$symbol $module"
+	fi
 }
 
 while read line; do
_

Patches currently in -mm which might be from leitao@debian.org are


