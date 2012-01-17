From: akpm@linux-foundation.org
Subject: [merged] kconfig-add-merge_configsh-script.patch removed from -mm tree
Date: Tue, 17 Jan 2012 13:00:55 -0800
Message-ID: <20120117210056.35BE3200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:63151 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab2AQVA7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2012 16:00:59 -0500
Received: by mail-fx0-f74.google.com with SMTP id p21so54354faa.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2012 13:00:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, Bruce.Ashfield@windriver.com, Dmitry.Fink@palm.com, Reinhard.Tartler@informatik.uni-erlangen.de, dvhart@linux.intel.com, ebmunson@us.ibm.com, gthelen@google.com, john.stultz@linaro.org, mmarek@suse.cz, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kconfig: add merge_config.sh script
has been removed from the -mm tree.  Its filename was
     kconfig-add-merge_configsh-script.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: john stultz <johnstul@us.ibm.com>
Subject: kconfig: add merge_config.sh script

After noticing almost every distro has their own method of managing config
fragments, I went looking at some best practices, and wanted to try to
consolidate some of the different approaches so this fairly simple
infrastructure can be shared (and new distros/build systems don't have to
implement yet another config fragment merge script).

This script is most influenced by the Windriver tools used in the Yocto
Project, reusing some portions found there.

This script merges multiple config fragments, warning on any overridden
values.  It then sets any unspecified values to their default, then
finally checks to make sure no specified value was dropped due to
unsatisfied dependencies.

I'm sure this implementation won't work for everyone, and I expect it will
need to evolve to adapt for various use cases.  But I think its a
reasonable starting point.

Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>
Cc: Dmitry Fink <Dmitry.Fink@palm.com>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Eric B Munson <ebmunson@us.ibm.com>
Cc: Bruce Ashfield <Bruce.Ashfield@windriver.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/merge_config.sh |  117 ++++++++++++++++++++++++++++++
 1 file changed, 117 insertions(+)

diff -puN /dev/null scripts/kconfig/merge_config.sh
--- /dev/null
+++ a/scripts/kconfig/merge_config.sh
@@ -0,0 +1,117 @@
+#!/bin/sh
+#  merge_config.sh - Takes a list of config fragment values, and merges
+#  them one by one. Provides warnings on overridden values, and specified
+#  values that did not make it to the resulting .config file (due to missed
+#  dependencies or config symbol removal).
+#
+#  Portions reused from kconf_check and generate_cfg:
+#  http://git.yoctoproject.org/cgit/cgit.cgi/yocto-kernel-tools/tree/tools/kconf_check
+#  http://git.yoctoproject.org/cgit/cgit.cgi/yocto-kernel-tools/tree/tools/generate_cfg
+#
+#  Copyright (c) 2009-2010 Wind River Systems, Inc.
+#  Copyright 2011 Linaro
+#
+#  This program is free software; you can redistribute it and/or modify
+#  it under the terms of the GNU General Public License version 2 as
+#  published by the Free Software Foundation.
+#
+#  This program is distributed in the hope that it will be useful,
+#  but WITHOUT ANY WARRANTY; without even the implied warranty of
+#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+#  See the GNU General Public License for more details.
+
+clean_up() {
+       rm -f $TMP_FILE
+       exit
+}
+trap clean_up SIGHUP SIGINT SIGTERM
+
+usage() {
+	echo "Usage: $0 [OPTIONS] [CONFIG [...]]"
+	echo "  -h    display this help text"
+	echo "  -m    only merge the fragments, do not execute the make command"
+	echo "  -n    use allnoconfig instead of alldefconfig"
+}
+
+MAKE=true
+ALLTARGET=alldefconfig
+
+while true; do
+	case $1 in
+	"-n")
+		ALLTARGET=allnoconfig
+		shift
+		continue
+		;;
+	"-m")
+		MAKE=false
+		shift
+		continue
+		;;
+	"-h")
+		usage
+		exit
+		;;
+	*)
+		break
+		;;
+	esac
+done
+
+
+
+MERGE_LIST=$*
+SED_CONFIG_EXP="s/^\(# \)\{0,1\}\(CONFIG_[a-zA-Z0-9_]*\)[= ].*/\2/p"
+TMP_FILE=$(mktemp ./.tmp.config.XXXXXXXXXX)
+
+# Merge files, printing warnings on overrided values
+for MERGE_FILE in $MERGE_LIST ; do
+	echo "Merging $MERGE_FILE"
+	CFG_LIST=$(sed -n "$SED_CONFIG_EXP" $MERGE_FILE)
+
+	for CFG in $CFG_LIST ; do
+		grep -q -w $CFG $TMP_FILE
+		if [ $? -eq 0 ] ; then
+			PREV_VAL=$(grep -w $CFG $TMP_FILE)
+			NEW_VAL=$(grep -w $CFG $MERGE_FILE)
+			if [ "x$PREV_VAL" != "x$NEW_VAL" ] ; then
+			echo Value of $CFG is redefined by fragment $MERGE_FILE:
+			echo Previous  value: $PREV_VAL
+			echo New value:       $NEW_VAL
+			echo
+			fi
+			sed -i "/$CFG[ =]/d" $TMP_FILE
+		fi
+	done
+	cat $MERGE_FILE >> $TMP_FILE
+done
+
+if [ "$MAKE" = "false" ]; then
+	cp $TMP_FILE .config
+	echo "#"
+	echo "# merged configuration written to .config (needs make)"
+	echo "#"
+	clean_up
+	exit
+fi
+
+# Use the merged file as the starting point for:
+# alldefconfig: Fills in any missing symbols with Kconfig default
+# allnoconfig: Fills in any missing symbols with # CONFIG_* is not set
+make KCONFIG_ALLCONFIG=$TMP_FILE $ALLTARGET
+
+
+# Check all specified config values took (might have missed-dependency issues)
+for CFG in $(sed -n "$SED_CONFIG_EXP" $TMP_FILE); do
+
+	REQUESTED_VAL=$(sed -n "$SED_CONFIG_EXP" $TMP_FILE | grep -w -e "$CFG")
+	ACTUAL_VAL=$(sed -n "$SED_CONFIG_EXP" .config | grep -w -e "$CFG")
+	if [ "x$REQUESTED_VAL" != "x$ACTUAL_VAL" ] ; then
+		echo "Value requested for $CFG not in final .config"
+		echo "Requested value:  $REQUESTED_VAL"
+		echo "Actual value:     $ACTUAL_VAL"
+		echo ""
+	fi
+done
+
+clean_up
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

origin.patch
linux-next.patch
hpet-factor-timer-allocate-from-open.patch

