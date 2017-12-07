From: akpm@linux-foundation.org
Subject: + scripts-faddr2line-fix-cross_compile-unset-error.patch added to -mm tree
Date: Wed, 06 Dec 2017 16:02:36 -0800
Message-ID: <5a28851c.QDgxMCaUnBTx2Gtw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44728 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbdLGACh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2017 19:02:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: changcheng.liu@intel.com, gregkh@linuxfoundation.org, neilb@suse.com, pombredanne@nexb.com, richard@nod.at, richard.weinberger@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/faddr2line: fix CROSS_COMPILE unset error
has been added to the -mm tree.  Its filename is
     scripts-faddr2line-fix-cross_compile-unset-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-faddr2line-fix-cross_compile-unset-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-faddr2line-fix-cross_compile-unset-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from changcheng.liu@intel.com are

scripts-faddr2line-fix-cross_compile-unset-error.patch

