From: akpm@linux-foundation.org
Subject: + merge_configsh-use-signal-names-compatible-with-dash-and-bash.patch added to -mm tree
Date: Mon, 21 Nov 2011 13:30:53 -0800
Message-ID: <201111212130.pALLUsoD015841@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:52941 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915Ab1KUVa5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2011 16:30:57 -0500
Received: by yenm12 with SMTP id m12so181106yen.1
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2011 13:30:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dvhart@linux.intel.com, john.stultz@linaro.org, mmarek@suse.cz


The patch titled
     Subject: merge_config.sh: use signal names compatible with dash and bash
has been added to the -mm tree.  Its filename is
     merge_configsh-use-signal-names-compatible-with-dash-and-bash.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Subject: Subject: merge_config.sh: use signal names compatible with dash and bash

Patches currently in -mm which might be from dvhart@linux.intel.com are

linux-next.patch
kconfig-add-merge_configsh-script.patch
merge_configsh-use-signal-names-compatible-with-dash-and-bash.patch
merge_configsh-whitespace-cleanup.patch

