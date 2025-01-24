Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE901D6DC8
	for <mm-commits@vger.kernel.org>; Fri, 24 Jan 2025 06:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737700771; cv=none; b=jbKyzU7DImr24Lr3kXBGInHxD+9NDggh9DTEMTCVoMRgmP6oUT+gvuINR4P9VIOP/KNTK34yKBHvS0d0pfLJDLFcPQ25TW2KEjRabZLpPY0w+uEUg46v0bqOVswa+ye4naHXuV0hsLJtkfPy0Rsb02Sa9gwnOKMHGV1YpAk2nUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737700771; c=relaxed/simple;
	bh=9NVShtqNg/ZoWtwpwNrDugin3RkCkR2XI4dhayYL6oc=;
	h=Date:To:From:Subject:Message-Id; b=ehXafx/n4891YwYu3A+X0m9sZLMOJW9mkRgUBf0UMGqTfnX1RkMI1LA34hyZ3yHYV9+yG3Iiq1zPKhT58vk0YQQAHqiYTORVeXzYLPyzt2+CC6i7vS+e+DXMOXL8DuWiRcom1CWeMwn/wWcD+feeUR4V4sYdaNjhtgpezdAxodM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RQ4xdZyl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RQ4xdZyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3FC7C4CED2;
	Fri, 24 Jan 2025 06:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737700771;
	bh=9NVShtqNg/ZoWtwpwNrDugin3RkCkR2XI4dhayYL6oc=;
	h=Date:To:From:Subject:From;
	b=RQ4xdZylHzvdGcZf5PtpGekO3TOqZTWUaw9oeDBEEjSbWuo8nau+o14z6wxLtMlE7
	 VOgT87Gpm9FVj1Xd16Rkh0fqfvOBtn9gZ8dYo/A3+5GeJ1t5Bpy03Yx4G07mGNIN6q
	 9qwflZfoBRRx6n8IN3Hj4ZJY8fFC94Vtv2xhGDoU=
Date: Thu, 23 Jan 2025 22:39:30 -0800
To: mm-commits@vger.kernel.org,russ.weight@linux.dev,rafael@kernel.org,nicolas@fjasle.eu,nathan@kernel.org,mcgrof@kernel.org,masahiroy@kernel.org,gregkh@linuxfoundation.org,dakr@kernel.org,cascardo@igalia.com,gpiccoli@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-add-script-to-extract-built-in-firmware-blobs.patch added to mm-nonmm-unstable branch
Message-Id: <20250124063930.F3FC7C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts: add script to extract built-in firmware blobs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-add-script-to-extract-built-in-firmware-blobs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-add-script-to-extract-built-in-firmware-blobs.patch

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
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Subject: scripts: add script to extract built-in firmware blobs
Date: Mon, 20 Jan 2025 16:04:26 -0300

Through the options CONFIG_EXTRA_FIRMWARE{_DIR} one is able to build a
kernel including firmware blobs in a built-in fashion.  This is usually
the case of built-in drivers that require some blobs in order to work
properly, for example, like in non-initrd based systems.

Add hereby a script to extract these blobs from a non-stripped vmlinux,
similar to the idea of "extract-ikconfig".  The firmware loader interface
saves such built-in blobs as rodata entries, having a field for the FW
name as "_fw_<module_name>_<firmware_name>_bin"; the tool extracts files
named "<module_name>_<firmware_name>" for each rodata firmware entry
detected.  It makes use of awk, bash, dd and readelf, pretty standard
tooling for Linux development.

Link: https://lkml.kernel.org/r/20250120190436.127578-1-gpiccoli@igalia.com
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Suggested-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Reviewed-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Russ Weight <russ.weight@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/extract-fwblobs |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/scripts/extract-fwblobs a/scripts/extract-fwblobs
new file mode 100755
--- /dev/null
+++ a/scripts/extract-fwblobs
@@ -0,0 +1,31 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# -----------------------------------------------------------------------------
+# Extracts the vmlinux built-in firmware blobs - requires a non-stripped image
+# -----------------------------------------------------------------------------
+
+if [ -z "$1" ]; then
+	echo "Must provide a non-stripped vmlinux as argument"
+	exit 1
+fi
+
+read -r RD_ADDR_HEX RD_OFF_HEX <<< "$( readelf -SW "$1" |\
+grep -w rodata | awk '{print "0x"$5" 0x"$6}' )"
+
+FW_SYMS="$(readelf -sW "$1" |\
+awk -n '/fw_end/ { end=$2 ; print name " 0x" start " 0x" end; } { start=$2; name=$8; }')"
+
+while IFS= read -r entry; do
+	read -r FW_NAME FW_ADDR_ST_HEX FW_ADDR_END_HEX <<< "$entry"
+
+	# Notice kernel prepends _fw_ and appends _bin to the FW name
+	# in rodata; hence we hereby filter that out.
+	FW_NAME=${FW_NAME:4:-4}
+
+	FW_OFFSET="$(printf "%d" $((FW_ADDR_ST_HEX - RD_ADDR_HEX + RD_OFF_HEX)))"
+	FW_SIZE="$(printf "%d" $((FW_ADDR_END_HEX - FW_ADDR_ST_HEX)))"
+
+	dd if="$1" of="./${FW_NAME}" bs="${FW_SIZE}" count=1 iflag=skip_bytes skip="${FW_OFFSET}"
+done <<< "${FW_SYMS}"
+
_

Patches currently in -mm which might be from gpiccoli@igalia.com are

scripts-add-script-to-extract-built-in-firmware-blobs.patch

