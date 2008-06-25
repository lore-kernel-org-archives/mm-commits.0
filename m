From: akpm@linux-foundation.org
Subject: + iwlwifi-fix-build-for-config_input=n.patch added to -mm tree
Date: Wed, 25 Jun 2008 16:12:17 -0700
Message-ID: <200806252312.m5PNCHeK031649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754082AbYFYXMq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jun 2008 19:12:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, linville@tuxdriver.com


The patch titled
     iwlwifi: fix build for CONFIG_INPUT=n
has been added to the -mm tree.  Its filename is
     iwlwifi-fix-build-for-config_input=n.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iwlwifi: fix build for CONFIG_INPUT=n
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix iwlwifi so that it builds cleanly with CONFIG_INPUT=n.
Also free the input device on exit.

drivers/built-in.o: In function `iwl_rfkill_unregister':
(.text+0xbf430): undefined reference to `input_unregister_device'
drivers/built-in.o: In function `iwl_rfkill_init':
(.text+0xbf51c): undefined reference to `input_allocate_device'
drivers/built-in.o: In function `iwl_rfkill_init':
(.text+0xbf5bf): undefined reference to `input_register_device'
drivers/built-in.o: In function `iwl_rfkill_init':
(.text+0xbf5e9): undefined reference to `input_free_device'
net/built-in.o: In function `rfkill_disconnect':
rfkill-input.c:(.text+0xe71e1): undefined reference to `input_close_device'
rfkill-input.c:(.text+0xe71e9): undefined reference to `input_unregister_handle'
net/built-in.o: In function `rfkill_connect':
rfkill-input.c:(.text+0xe723e): undefined reference to `input_register_handle'
rfkill-input.c:(.text+0xe724d): undefined reference to `input_open_device'
rfkill-input.c:(.text+0xe725c): undefined reference to `input_unregister_handle'
net/built-in.o: In function `rfkill_handler_init':
rfkill-input.c:(.init.text+0x36ec): undefined reference to `input_register_handler'
net/built-in.o: In function `rfkill_handler_exit':
rfkill-input.c:(.exit.text+0x112c): undefined reference to `input_unregister_handler'
make[1]: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/iwlwifi/Kconfig      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rfkill.c |   11 ++++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff -puN drivers/net/wireless/iwlwifi/Kconfig~iwlwifi-fix-build-for-config_input=n drivers/net/wireless/iwlwifi/Kconfig
--- a/drivers/net/wireless/iwlwifi/Kconfig~iwlwifi-fix-build-for-config_input=n
+++ a/drivers/net/wireless/iwlwifi/Kconfig
@@ -8,7 +8,7 @@ config IWLCORE
 	select MAC80211_LEDS if IWLWIFI_LEDS
 	select LEDS_CLASS if IWLWIFI_LEDS
 	select RFKILL if IWLWIFI_RFKILL
-	select RFKILL_INPUT if IWLWIFI_RFKILL
+	select RFKILL_INPUT if (IWLWIFI_RFKILL && INPUT)
 
 config IWLWIFI_LEDS
 	bool
diff -puN drivers/net/wireless/iwlwifi/iwl-rfkill.c~iwlwifi-fix-build-for-config_input=n drivers/net/wireless/iwlwifi/iwl-rfkill.c
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c~iwlwifi-fix-build-for-config_input=n
+++ a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -95,6 +95,7 @@ int iwl_rfkill_init(struct iwl_priv *pri
 	priv->rfkill_mngr.rfkill->dev.class->suspend = NULL;
 	priv->rfkill_mngr.rfkill->dev.class->resume = NULL;
 
+#if defined(CONFIG_RFKILL_INPUT) || defined(CONFIG_RFKILL_INPUT_MODULE)
 	priv->rfkill_mngr.input_dev = input_allocate_device();
 	if (!priv->rfkill_mngr.input_dev) {
 		IWL_ERROR("Unable to allocate rfkill input device.\n");
@@ -109,6 +110,7 @@ int iwl_rfkill_init(struct iwl_priv *pri
 	priv->rfkill_mngr.input_dev->dev.parent = device;
 	priv->rfkill_mngr.input_dev->evbit[0] = BIT(EV_KEY);
 	set_bit(KEY_WLAN, priv->rfkill_mngr.input_dev->keybit);
+#endif
 
 	ret = rfkill_register(priv->rfkill_mngr.rfkill);
 	if (ret) {
@@ -116,11 +118,13 @@ int iwl_rfkill_init(struct iwl_priv *pri
 		goto free_input_dev;
 	}
 
+#if defined(CONFIG_RFKILL_INPUT) || defined(CONFIG_RFKILL_INPUT_MODULE)
 	ret = input_register_device(priv->rfkill_mngr.input_dev);
 	if (ret) {
 		IWL_ERROR("Unable to register rfkill input device: %d\n", ret);
 		goto unregister_rfkill;
 	}
+#endif
 
 	IWL_DEBUG_RF_KILL("RFKILL initialization complete.\n");
 	return ret;
@@ -130,8 +134,10 @@ unregister_rfkill:
 	priv->rfkill_mngr.rfkill = NULL;
 
 free_input_dev:
+#if defined(CONFIG_RFKILL_INPUT) || defined(CONFIG_RFKILL_INPUT_MODULE)
 	input_free_device(priv->rfkill_mngr.input_dev);
 	priv->rfkill_mngr.input_dev = NULL;
+#endif
 
 freed_rfkill:
 	if (priv->rfkill_mngr.rfkill != NULL)
@@ -147,13 +153,16 @@ EXPORT_SYMBOL(iwl_rfkill_init);
 void iwl_rfkill_unregister(struct iwl_priv *priv)
 {
 
+#if defined(CONFIG_RFKILL_INPUT) || defined(CONFIG_RFKILL_INPUT_MODULE)
 	if (priv->rfkill_mngr.input_dev)
 		input_unregister_device(priv->rfkill_mngr.input_dev);
+	input_free_device(priv->rfkill_mngr.input_dev);
+	priv->rfkill_mngr.input_dev = NULL;
+#endif
 
 	if (priv->rfkill_mngr.rfkill)
 		rfkill_unregister(priv->rfkill_mngr.rfkill);
 
-	priv->rfkill_mngr.input_dev = NULL;
 	priv->rfkill_mngr.rfkill = NULL;
 }
 EXPORT_SYMBOL(iwl_rfkill_unregister);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

fujitsu-laptop-depends-on-input.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
git-unionfs.patch
iwlwifi-fix-build-for-config_input=n.patch
audit-fix-kernel-doc-parameter-notation.patch
vmallocinfo-add-numa-information.patch
vmallocinfo-add-numa-information-fix.patch
pm-remove-obsolete-piece-of-pm-documentation-rev-2.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
uio-howtotmpl-use-standard-copyright-legal-markings.patch
uio-howtotmpl-use-unique-output-names.patch
bsdacct-stir-up-comments-around-acct_process.patch
documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections.patch
profile-likely-unlikely-macros.patch

