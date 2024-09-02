Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563F47DA9E
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248801; cv=none; b=iknOZ1uscIOR2yTZArQMXJSXBoGYGkg7zR1c3PqTCx+VpggyINxhmvmiGB6nib/D5+Dg5KLVf851eq6jw3OzMlcD0GdfzURSVVf+SvME93avlaMeDKdLl/+CbppKZ6I9LzU9NgkfJvCQkszXpxfegsL0mOyQGuNSMG9BChMHXEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248801; c=relaxed/simple;
	bh=pjtSkRuNTcqomns0SRKKP5yfQPtoTXcoTa81JT0zLss=;
	h=Date:To:From:Subject:Message-Id; b=gSOhGl/vBAg5lYOILkRCYJnUVnZUEahEX9dIWAvL8SoTk8/dfzXlFa0E2OR/sw0lhe0CfLH1ilxqjhqIuv/kJCfaW/ciR90+ZiNvEvOUodrCSoRPuCtYD0QH5moZWZ/h5expBzY+vTHV7PLiHsNvt+nqqeG0Bu9CdJtzXxpx5So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rmO9tChR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rmO9tChR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8FBC4CEC2;
	Mon,  2 Sep 2024 03:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248801;
	bh=pjtSkRuNTcqomns0SRKKP5yfQPtoTXcoTa81JT0zLss=;
	h=Date:To:From:Subject:From;
	b=rmO9tChRzBFLEVfMo/qa4yGHMEY197CWtsh3LBIz4Pmi0r6qgMJPd6ipBv9s62A2l
	 7IFw43FTwoUdajnpaXSQdztoWEOjHB3uQ5HixStJBZ4UcZg1bcgIm9G73Sbw90Xtl9
	 Wun+LPGO9KM08eZDWbo/a9a535ghY6LgIgCIll60=
Date: Sun, 01 Sep 2024 20:46:40 -0700
To: mm-commits@vger.kernel.org,akinobu.mita@gmail.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fault-injection-enhance-failcmd-to-exit-on-non-hex-address-input.patch removed from -mm tree
Message-Id: <20240902034641.2E8FBC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fault-injection: enhance failcmd to exit on non-hex address input
has been removed from the -mm tree.  Its filename was
     fault-injection-enhance-failcmd-to-exit-on-non-hex-address-input.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: fault-injection: enhance failcmd to exit on non-hex address input
Date: Mon, 29 Jul 2024 01:45:08 -0700

The failcmd.sh script in the fault-injection toolkit does not currently
validate whether the provided address is in hexadecimal format.  This can
lead to silent failures if the address is sourced from places like
`/proc/kallsyms`, which omits the '0x' prefix, potentially causing users
to operate under incorrect assumptions.

Introduce a new function, `exit_if_not_hex`, which checks the format of
the provided address and exits with an error message if the address is not
a valid hexadecimal number.

This enhancement prevents users from running the command with improperly
formatted addresses, thus improving the robustness and usability of the
failcmd tool.

Link: https://lkml.kernel.org/r/20240729084512.3349928-1-leitao@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/fault-injection/failcmd.sh |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/tools/testing/fault-injection/failcmd.sh~fault-injection-enhance-failcmd-to-exit-on-non-hex-address-input
+++ a/tools/testing/fault-injection/failcmd.sh
@@ -64,6 +64,14 @@ ENVIRONMENT
 EOF
 }
 
+exit_if_not_hex() {
+    local value="$1"
+    if ! [[ $value =~ ^0x[0-9a-fA-F]+$ ]]; then
+        echo "Error: The provided value '$value' is not a valid hexadecimal number." >&2
+        exit 1
+    fi
+}
+
 if [ $UID != 0 ]; then
 	echo must be run as root >&2
 	exit 1
@@ -160,18 +168,22 @@ while true; do
 		shift 2
 		;;
 	--require-start)
+		exit_if_not_hex "$2"
 		echo $2 > $FAULTATTR/require-start
 		shift 2
 		;;
 	--require-end)
+		exit_if_not_hex "$2"
 		echo $2 > $FAULTATTR/require-end
 		shift 2
 		;;
 	--reject-start)
+		exit_if_not_hex "$2"
 		echo $2 > $FAULTATTR/reject-start
 		shift 2
 		;;
 	--reject-end)
+		exit_if_not_hex "$2"
 		echo $2 > $FAULTATTR/reject-end
 		shift 2
 		;;
_

Patches currently in -mm which might be from leitao@debian.org are


