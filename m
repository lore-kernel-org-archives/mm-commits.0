From: akpm@linux-foundation.org
Subject: [patch 09/28] scripts/faddr2line: extend usage on generic arch
Date: Wed, 29 Nov 2017 16:10:25 -0800
Message-ID: <5a1f4c71.i5GrwDRpiaODqcrH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60552 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753344AbdK3AK0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 19:10:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, changcheng.liu@intel.com, gregkh@linuxfoundation.org, kstewart@linuxfoundation.org, neilb@suse.com, tglx@linutronix.de

From: "Liu, Changcheng" <changcheng.liu@intel.com>
Subject: scripts/faddr2line: extend usage on generic arch

When cross-compiling, fadd2line should use the binary tool used for the
target system, rather than that of the host.

Link: http://lkml.kernel.org/r/20171121092911.GA150711@sofia
Signed-off-by: Liu Changcheng <changcheng.liu@intel.com>
Cc: Kate Stewart <kstewart@linuxfoundation.org>
Cc: NeilBrown <neilb@suse.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/faddr2line |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff -puN scripts/faddr2line~scripts-faddr2line-extend-usage-on-generic-arch scripts/faddr2line
--- a/scripts/faddr2line~scripts-faddr2line-extend-usage-on-generic-arch
+++ a/scripts/faddr2line
@@ -44,9 +44,16 @@
 set -o errexit
 set -o nounset
 
+READELF="${CROSS_COMPILE}readelf"
+ADDR2LINE="${CROSS_COMPILE}addr2line"
+SIZE="${CROSS_COMPILE}size"
+NM="${CROSS_COMPILE}nm"
+
 command -v awk >/dev/null 2>&1 || die "awk isn't installed"
-command -v readelf >/dev/null 2>&1 || die "readelf isn't installed"
-command -v addr2line >/dev/null 2>&1 || die "addr2line isn't installed"
+command -v ${READELF} >/dev/null 2>&1 || die "readelf isn't installed"
+command -v ${ADDR2LINE} >/dev/null 2>&1 || die "addr2line isn't installed"
+command -v ${SIZE} >/dev/null 2>&1 || die "size isn't installed"
+command -v ${NM} >/dev/null 2>&1 || die "nm isn't installed"
 
 usage() {
 	echo "usage: faddr2line <object file> <func+offset> <func+offset>..." >&2
@@ -69,10 +76,10 @@ die() {
 find_dir_prefix() {
 	local objfile=$1
 
-	local start_kernel_addr=$(readelf -sW $objfile | awk '$8 == "start_kernel" {printf "0x%s", $2}')
+	local start_kernel_addr=$(${READELF} -sW $objfile | awk '$8 == "start_kernel" {printf "0x%s", $2}')
 	[[ -z $start_kernel_addr ]] && return
 
-	local file_line=$(addr2line -e $objfile $start_kernel_addr)
+	local file_line=$(${ADDR2LINE} -e $objfile $start_kernel_addr)
 	[[ -z $file_line ]] && return
 
 	local prefix=${file_line%init/main.c:*}
@@ -104,7 +111,7 @@ __faddr2line() {
 
 	# Go through each of the object's symbols which match the func name.
 	# In rare cases there might be duplicates.
-	file_end=$(size -Ax $objfile | awk '$1 == ".text" {print $2}')
+	file_end=$(${SIZE} -Ax $objfile | awk '$1 == ".text" {print $2}')
 	while read symbol; do
 		local fields=($symbol)
 		local sym_base=0x${fields[0]}
@@ -156,10 +163,10 @@ __faddr2line() {
 
 		# pass real address to addr2line
 		echo "$func+$offset/$sym_size:"
-		addr2line -fpie $objfile $addr | sed "s; $dir_prefix\(\./\)*; ;"
+		${ADDR2LINE} -fpie $objfile $addr | sed "s; $dir_prefix\(\./\)*; ;"
 		DONE=1
 
-	done < <(nm -n $objfile | awk -v fn=$func -v end=$file_end '$3 == fn { found=1; line=$0; start=$1; next } found == 1 { found=0; print line, "0x"$1 } END {if (found == 1) print line, end; }')
+	done < <(${NM} -n $objfile | awk -v fn=$func -v end=$file_end '$3 == fn { found=1; line=$0; start=$1; next } found == 1 { found=0; print line, "0x"$1 } END {if (found == 1) print line, end; }')
 }
 
 [[ $# -lt 2 ]] && usage
_
