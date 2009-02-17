From: akpm@linux-foundation.org
Subject: + wireless-fix-for-config_nl80211=n.patch added to -mm tree
Date: Tue, 17 Feb 2009 15:42:08 -0800
Message-ID: <200902172342.n1HNg8lv015063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752793AbZBQXnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 18:43:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, johannes@sipsolutions.net, linville@tuxdriver.com


The patch titled
     wireless: fix for CONFIG_NL80211=n
has been added to the -mm tree.  Its filename is
     wireless-fix-for-config_nl80211=n.patch

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
Subject: wireless: fix for CONFIG_NL80211=n
From: Randy Dunlap <randy.dunlap@oracle.com>

Add empty function for case of CONFIG_NL80211=n:

net/wireless/scan.c:35: error: implicit declaration of function 'nl80211_send_scan_aborted'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/wireless/nl80211.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN net/wireless/nl80211.h~wireless-fix-for-config_nl80211=n net/wireless/nl80211.h
--- a/net/wireless/nl80211.h~wireless-fix-for-config_nl80211=n
+++ a/net/wireless/nl80211.h
@@ -27,6 +27,10 @@ static inline void
 nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
 		       struct net_device *netdev)
 {}
+static inline void nl80211_send_scan_aborted(
+					struct cfg80211_registered_device *rdev,
+					struct net_device *netdev)
+{}
 #endif /* CONFIG_NL80211 */
 
 #endif /* __NET_WIRELESS_NL80211_H */
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
input-ad7879-touchscreen-driver.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
esp-fix-section-mismatch-warning.patch
cciss-pci-power-management-reset-for-kexec.patch
usb-fix-ehci-printk-formats.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
wireless-fix-for-config_nl80211=n.patch
x86-dell-laptop-depends-on-power_supply.patch
x86-oqo-depends-on-input_polldev.patch
max3100-spi-uart-driver.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
atyfb-fix-header-file-trailing-whitespace.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-fix.patch
documentation-ignore-byproducts-from-latex.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch
reiser4-export-remove_from_page_cache-fix.patch

