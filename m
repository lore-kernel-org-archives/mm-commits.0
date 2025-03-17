Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1417C2FB2
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189485; cv=none; b=epM776n0LJ1u4CbZuwyPPC3+CT9wKgBeM3571S3KdfjcnI0He4FXRx6SnOxvdSnVANA/Z5N0+z3LDNttOeosHf1zfqfKhUM4YgGHW10xxSb4ukUTROx0vmhi8diLov2euCL8danlB4jqX1J3j37J9tmdHb+nfALBd3gvXtxdlfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189485; c=relaxed/simple;
	bh=DC9i4b2V5kpYnagTbeAJfgD98UBJlFMmHqy3HY4VI4s=;
	h=Date:To:From:Subject:Message-Id; b=qvSlSLjY78fsqbcSAPr/u9eZ1mwOgY2kv66UFIg/l3WbagYipqYezqeQoURMQVKC3q/YVIRmqRoCrwawOxljXJgLFr6Ndk8S1biOVp3AvQOkVtU7DfC/V0bZWlzfzviSvmIzOhVfMz65O7jxtv0uG6jZio0bdg9ROpRBQYg4EI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qqEFbEy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qqEFbEy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718BCC4CEEC;
	Mon, 17 Mar 2025 05:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189484;
	bh=DC9i4b2V5kpYnagTbeAJfgD98UBJlFMmHqy3HY4VI4s=;
	h=Date:To:From:Subject:From;
	b=qqEFbEy85kAqok8ECIQM9yy4r7ZKVfUHkIT1w0/YGj64dgTyHUOHb8lcT/A4Upogz
	 ElSv/G2rXOCts/OQQSXGuWtHcZoAiXq15sRWdN1mWjVlnu+m1dK60LcGWbUXdasOxD
	 F07QQY08bjMDkWJgY1vD1xCxM/EnzsQ7H2NDxtvg=
Date: Sun, 16 Mar 2025 22:31:23 -0700
To: mm-commits@vger.kernel.org,russ.weight@linux.dev,rafael@kernel.org,nicolas@fjasle.eu,nathan@kernel.org,mcgrof@kernel.org,masahiroy@kernel.org,gregkh@linuxfoundation.org,dakr@kernel.org,cascardo@igalia.com,gpiccoli@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-add-script-to-extract-built-in-firmware-blobs.patch removed from -mm tree
Message-Id: <20250317053124.718BCC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts: add script to extract built-in firmware blobs
has been removed from the -mm tree.  Its filename was
     scripts-add-script-to-extract-built-in-firmware-blobs.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Subject: scripts: add script to extract built-in firmware blobs
Date: Mon, 20 Jan 2025 16:04:26 -0300

There is currently no tool to extract a firmware blob that is built-in
on vmlinux to the best of my knowledge.  So if we have a kernel image
containing the blobs, and we want to rebuild the kernel with some debug
patches for example (and given that the image also has IKCONFIG=y), we
currently can't do that for the same versions for all the firmware
blobs, _unless_ we have exact commits of linux-firmware for the
specific versions for each firmware included.

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

With this tool, we can blindly extract the FWs and easily re-add them
in the new debug kernel build, allowing a more deterministic testing
without the burden of "hunting down" the proper version of each
firmware binary.

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

 scripts/extract-fwblobs |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/scripts/extract-fwblobs a/scripts/extract-fwblobs
new file mode 100755
--- /dev/null
+++ a/scripts/extract-fwblobs
@@ -0,0 +1,30 @@
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
_

Patches currently in -mm which might be from gpiccoli@igalia.com are


