From: akpm@linux-foundation.org
Subject: [merged] merge_configsh-use-signal-names-compatible-with-dash-and-bash.patch removed from -mm tree
Date: Tue, 17 Jan 2012 13:01:00 -0800
Message-ID: <20120117210100.A8E571E005A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:42106 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab2AQVBB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2012 16:01:01 -0500
Received: by mail-qy0-f202.google.com with SMTP id g1so43027qcs.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2012 13:01:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvhart@linux.intel.com, john.stultz@linaro.org, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: merge_config.sh: use signal names compatible with dash and bash
has been removed from the -mm tree.  Its filename was
     merge_configsh-use-signal-names-compatible-with-dash-and-bash.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Darren Hart <dvhart@linux.intel.com>
Subject: merge_config.sh: use signal names compatible with dash and bash

The SIGHUP SIGINT and SIGTERM names caused failures when running
merge_config.sh with the dash shell.  Dropping the "SIG" component makes
the script work in both bash and dash.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Acked-by: John Stultz <john.stultz@linaro.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/merge_config.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/kconfig/merge_config.sh~merge_configsh-use-signal-names-compatible-with-dash-and-bash scripts/kconfig/merge_config.sh
--- a/scripts/kconfig/merge_config.sh~merge_configsh-use-signal-names-compatible-with-dash-and-bash
+++ a/scripts/kconfig/merge_config.sh
@@ -24,7 +24,7 @@ clean_up() {
        rm -f $TMP_FILE
        exit
 }
-trap clean_up SIGHUP SIGINT SIGTERM
+trap clean_up HUP INT TERM
 
 usage() {
 	echo "Usage: $0 [OPTIONS] [CONFIG [...]]"
_

Patches currently in -mm which might be from dvhart@linux.intel.com are

origin.patch
linux-next.patch

