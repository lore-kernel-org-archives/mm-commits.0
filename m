Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E43D18A951
	for <mm-commits@vger.kernel.org>; Tue, 30 Jul 2024 22:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722378635; cv=none; b=nV/1h+askc/1Ft41hCJkyuTe7QtTg6S0cYNK1uWTb6ek04a27P5Id4FKDrvsq2q0ObJ1HZwtmlQps9uC6qr12NSIt+DW4wR79hWVENfC/eeNBZtaM3VD72sVgubXUO1rDijghC6dHT5Kphr3MCCphD9si2ofLrX7Uu+vcyB/JPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722378635; c=relaxed/simple;
	bh=9CmJv77m+Ro8gMJmbtBaOgPYYCneN96ANWvn4p60wJc=;
	h=Date:To:From:Subject:Message-Id; b=CCH/dYNdZNxiDJz3rpV45LqS8zIeucYiKyVivhRL7q3ZnQIPhHtJl0LEhSYZ6g8/G7dVhHkkz0Cesjkxiq+KNE/CknNHZUn2p53JLg2SHwuUa62YypS4Xeeipmc1Xa5aWBoYzCYHlKZMEcSsHAp3457gA+HMpouqjqgJ+YNeCxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K7HISzKV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K7HISzKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F52C32782;
	Tue, 30 Jul 2024 22:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722378635;
	bh=9CmJv77m+Ro8gMJmbtBaOgPYYCneN96ANWvn4p60wJc=;
	h=Date:To:From:Subject:From;
	b=K7HISzKVbqKIGURiotAyeM+eJiSA9AgFTtEJLAdC1NlzlWKPALZ8miWOSX0Dltkui
	 km+y5rHd6rKE3lXwMuxRCiOnIeI53JqpcalyEqC4XzsIoQC5mdYgBRfEhT6HWmcWLk
	 dVipCZ41wn2+PhufOcHlv2V1KiHcA+3mecSE04eg=
Date: Tue, 30 Jul 2024 15:30:34 -0700
To: mm-commits@vger.kernel.org,akinobu.mita@gmail.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fault-injection-enhance-failcmd-to-exit-on-non-hex-address-input.patch added to mm-nonmm-unstable branch
Message-Id: <20240730223035.58F52C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fault-injection: enhance failcmd to exit on non-hex address input
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fault-injection-enhance-failcmd-to-exit-on-non-hex-address-input.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fault-injection-enhance-failcmd-to-exit-on-non-hex-address-input.patch

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

failcmd-add-script-file-in-maintainers.patch
fault-injection-enhance-failcmd-to-exit-on-non-hex-address-input.patch

