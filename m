From: akpm@linux-foundation.org
Subject: + clk-add-non-config_have_clk-routines.patch added to -mm tree
Date: Tue, 08 May 2012 15:32:44 -0700
Message-ID: <20120508223245.11E03A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:56810 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757731Ab2EHWcq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2012 18:32:46 -0400
Received: by yhgm50 with SMTP id m50so845570yhg.1
        for <mm-commits@vger.kernel.org>; Tue, 08 May 2012 15:32:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viresh.kumar@st.com


The patch titled
     Subject: clk: Add non CONFIG_HAVE_CLK routines
has been added to the -mm tree.  Its filename is
     clk-add-non-config_have_clk-routines.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Viresh Kumar <viresh.kumar@st.com>
Subject: clk: Add non CONFIG_HAVE_CLK routines

Many drivers are shared between architectures that may or may not have HAVE_CLK
selected for them. To remove compilation errors for them we enclose clk_*()
calls in these drivers within #ifdef CONFIG_HAVE_CLK, #endif.

This patch removes the need of these CONFIG_HAVE_CLK statements, by introducing
dummy routines when HAVE_CLK is not selected by platforms. So, definition of
these routines will always be available. These calls will return error for
platforms that don't select HAVE_CLK.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---

index 70cf722..9f84b68 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/clk.h |  168 +++++++++++++++++++++++++++---------------
 1 file changed, 109 insertions(+), 59 deletions(-)

diff -puN include/linux/clk.h~clk-add-non-config_have_clk-routines include/linux/clk.h
--- a/include/linux/clk.h~clk-add-non-config_have_clk-routines
+++ a/include/linux/clk.h
@@ -84,6 +84,43 @@ int clk_notifier_unregister(struct clk *
 #endif /* !CONFIG_COMMON_CLK */
 
 /**
+ * clk_prepare - prepare a clock source
+ * @clk: clock source
+ *
+ * This prepares the clock source for use.
+ *
+ * Must not be called from within atomic context.
+ */
+#ifdef CONFIG_HAVE_CLK_PREPARE
+int clk_prepare(struct clk *clk);
+#else
+static inline int clk_prepare(struct clk *clk)
+{
+	might_sleep();
+	return 0;
+}
+#endif
+
+/**
+ * clk_unprepare - undo preparation of a clock source
+ * @clk: clock source
+ *
+ * This undoes a previously prepared clock.  The caller must balance
+ * the number of prepare and unprepare calls.
+ *
+ * Must not be called from within atomic context.
+ */
+#ifdef CONFIG_HAVE_CLK_PREPARE
+void clk_unprepare(struct clk *clk);
+#else
+static inline void clk_unprepare(struct clk *clk)
+{
+	might_sleep();
+}
+#endif
+
+#ifdef CONFIG_HAVE_CLK
+/**
  * clk_get - lookup and obtain a reference to a clock producer.
  * @dev: device for clock "consumer"
  * @id: clock comsumer ID
@@ -121,24 +158,6 @@ struct clk *clk_get(struct device *dev, 
 struct clk *devm_clk_get(struct device *dev, const char *id);
 
 /**
- * clk_prepare - prepare a clock source
- * @clk: clock source
- *
- * This prepares the clock source for use.
- *
- * Must not be called from within atomic context.
- */
-#ifdef CONFIG_HAVE_CLK_PREPARE
-int clk_prepare(struct clk *clk);
-#else
-static inline int clk_prepare(struct clk *clk)
-{
-	might_sleep();
-	return 0;
-}
-#endif
-
-/**
  * clk_enable - inform the system when the clock source should be running.
  * @clk: clock source
  *
@@ -166,47 +185,6 @@ int clk_enable(struct clk *clk);
  */
 void clk_disable(struct clk *clk);
 
-
-/**
- * clk_unprepare - undo preparation of a clock source
- * @clk: clock source
- *
- * This undoes a previously prepared clock.  The caller must balance
- * the number of prepare and unprepare calls.
- *
- * Must not be called from within atomic context.
- */
-#ifdef CONFIG_HAVE_CLK_PREPARE
-void clk_unprepare(struct clk *clk);
-#else
-static inline void clk_unprepare(struct clk *clk)
-{
-	might_sleep();
-}
-#endif
-
-/* clk_prepare_enable helps cases using clk_enable in non-atomic context. */
-static inline int clk_prepare_enable(struct clk *clk)
-{
-	int ret;
-
-	ret = clk_prepare(clk);
-	if (ret)
-		return ret;
-	ret = clk_enable(clk);
-	if (ret)
-		clk_unprepare(clk);
-
-	return ret;
-}
-
-/* clk_disable_unprepare helps cases using clk_disable in non-atomic context. */
-static inline void clk_disable_unprepare(struct clk *clk)
-{
-	clk_disable(clk);
-	clk_unprepare(clk);
-}
-
 /**
  * clk_get_rate - obtain the current clock rate (in Hz) for a clock source.
  *		  This is only valid once the clock source has been enabled.
@@ -297,6 +275,78 @@ struct clk *clk_get_parent(struct clk *c
  */
 struct clk *clk_get_sys(const char *dev_id, const char *con_id);
 
+#else /* !CONFIG_HAVE_CLK */
+
+static inline struct clk *clk_get(struct device *dev, const char *id)
+{
+	return NULL;
+}
+
+static inline struct clk *devm_clk_get(struct device *dev, const char *id)
+{
+	return NULL;
+}
+
+static inline void clk_put(struct clk *clk) {}
+
+static inline void devm_clk_put(struct device *dev, struct clk *clk) {}
+
+static inline int clk_enable(struct clk *clk)
+{
+	return 0;
+}
+
+static inline void clk_disable(struct clk *clk) {}
+
+static inline unsigned long clk_get_rate(struct clk *clk)
+{
+	return 0;
+}
+
+static inline int clk_set_rate(struct clk *clk, unsigned long rate)
+{
+	return 0;
+}
+
+static inline long clk_round_rate(struct clk *clk, unsigned long rate)
+{
+	return 0;
+}
+
+static inline int clk_set_parent(struct clk *clk, struct clk *parent)
+{
+	return 0;
+}
+
+static inline struct clk *clk_get_parent(struct clk *clk)
+{
+	return NULL;
+}
+
+#endif
+
+/* clk_prepare_enable helps cases using clk_enable in non-atomic context. */
+static inline int clk_prepare_enable(struct clk *clk)
+{
+	int ret;
+
+	ret = clk_prepare(clk);
+	if (ret)
+		return ret;
+	ret = clk_enable(clk);
+	if (ret)
+		clk_unprepare(clk);
+
+	return ret;
+}
+
+/* clk_disable_unprepare helps cases using clk_disable in non-atomic context. */
+static inline void clk_disable_unprepare(struct clk *clk)
+{
+	clk_disable(clk);
+	clk_unprepare(clk);
+}
+
 /**
  * clk_add_alias - add a new clock alias
  * @alias: name for clock alias
_
Subject: Subject: clk: Add non CONFIG_HAVE_CLK routines

Patches currently in -mm which might be from viresh.kumar@st.com are

linux-next.patch
drivers-thermal-spear_thermalc-add-device-tree-probing-capability.patch
clk-add-non-config_have_clk-routines.patch
clk-remove-redundant-depends-on-from-drivers-kconfig.patch
i2c-i2c-pxa-remove-conditional-compilation-of-clk-code.patch
usb-marvell-remove-conditional-compilation-of-clk-code.patch
usb-musb-remove-conditional-compilation-of-clk-code.patch
ata-pata_arasan-remove-conditional-compilation-of-clk-code.patch
ata-sata_mv-remove-conditional-compilation-of-clk-code.patch
net-c_can-remove-conditional-compilation-of-clk-code.patch
net-stmmac-remove-conditional-compilation-of-clk-code.patch
gadget-m66592-remove-conditional-compilation-of-clk-code.patch
gadget-r8a66597-remove-conditional-compilation-of-clk-code.patch
usb-host-r8a66597-remove-conditional-compilation-of-clk-code.patch
rtc-spear-add-device-tree-probing-capability.patch

