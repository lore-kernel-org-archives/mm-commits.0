From: akpm@linux-foundation.org
Subject: [patch 08/17] scripts/faddr2line: fix CROSS_COMPILE unset error
Date: Thu, 14 Dec 2017 15:32:48 -0800
Message-ID: <5a330a20.raCW2wsd2c7hWazC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54336 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754277AbdLNXcu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Dec 2017 18:32:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, changcheng.liu@intel.com, gregkh@linuxfoundation.org, neilb@suse.com, pombredanne@nexb.com, richard@nod.at, richard.weinberger@gmail.com, tglx@linutronix.de

From: "Liu, Changcheng" <changcheng.liu@intel.com>
Subject: scripts/faddr2line: fix CROSS_COMPILE unset error

faddr2line hit var unbound error when CROSS_COMPILE isn't set since
nounset option is set in bash script.

Link: http://lkml.kernel.org/r/20171206013022.GA83929@sofia
Fixes: 95a879825419 ("scripts/faddr2line: extend usage on generic arch")
Signed-off-by: Liu Changcheng <changcheng.liu@intel.com>
Reported-by: Richard Weinberger <richard.weinberger@gmail.com>
Reviewed-by: Richard Weinberger <richard@nod.at>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Philippe Ombredanne <pombredanne@nexb.com>
Cc: NeilBrown <neilb@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/faddr2line |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN scripts/faddr2line~scripts-faddr2line-fix-cross_compile-unset-error scripts/faddr2line
--- a/scripts/faddr2line~scripts-faddr2line-fix-cross_compile-unset-error
+++ a/scripts/faddr2line
@@ -44,10 +44,10 @@
 set -o errexit
 set -o nounset
 
-READELF="${CROSS_COMPILE}readelf"
-ADDR2LINE="${CROSS_COMPILE}addr2line"
-SIZE="${CROSS_COMPILE}size"
-NM="${CROSS_COMPILE}nm"
+READELF="${CROSS_COMPILE:-}readelf"
+ADDR2LINE="${CROSS_COMPILE:-}addr2line"
+SIZE="${CROSS_COMPILE:-}size"
+NM="${CROSS_COMPILE:-}nm"
 
 command -v awk >/dev/null 2>&1 || die "awk isn't installed"
 command -v ${READELF} >/dev/null 2>&1 || die "readelf isn't installed"
_
