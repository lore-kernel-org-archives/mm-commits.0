From: akpm@linux-foundation.org
Subject: + st-spear-pcie-gadget-documentation-for-support-of-multiple-device.patch added to -mm tree
Date: Fri, 04 Mar 2011 15:52:25 -0800
Message-ID: <201103042352.p24NqPaP011241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760148Ab1CDXxB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2011 18:53:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pratyush.anand@st.com, jbarnes@virtuousgeek.org, randy.dunlap@oracle.com, shiraz.hashim@st.com, viresh.kumar@st.com


The patch titled
     ST SPEAr: PCIe Gadget: Documentation for support of multiple device
has been added to the -mm tree.  Its filename is
     st-spear-pcie-gadget-documentation-for-support-of-multiple-device.patch

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
Subject: ST SPEAr: PCIe Gadget: Documentation for support of multiple device
From: Pratyush Anand <pratyush.anand@st.com>

Directory naming scheme for multiple PCIe device has been mentioned.

Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Viresh Kumar <viresh.kumar@st.com>
Cc: Shiraz Hashim <shiraz.hashim@st.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/configfs-spear-pcie-gadget |    3 ++-
 Documentation/misc-devices/spear-pcie-gadget.txt     |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN Documentation/ABI/testing/configfs-spear-pcie-gadget~st-spear-pcie-gadget-documentation-for-support-of-multiple-device Documentation/ABI/testing/configfs-spear-pcie-gadget
--- a/Documentation/ABI/testing/configfs-spear-pcie-gadget~st-spear-pcie-gadget-documentation-for-support-of-multiple-device
+++ a/Documentation/ABI/testing/configfs-spear-pcie-gadget
@@ -13,7 +13,8 @@ Description:
 	in /config directory use:
 	# mount -t configfs none /config/
 
-	/config/pcie-gadget/
+	For nth PCIe Device Controller
+	/config/pcie-gadget.n/
 		link ... used to enable ltssm and read its status.
 		int_type ...used to configure and read type of supported
 			interrupt
diff -puN Documentation/misc-devices/spear-pcie-gadget.txt~st-spear-pcie-gadget-documentation-for-support-of-multiple-device Documentation/misc-devices/spear-pcie-gadget.txt
--- a/Documentation/misc-devices/spear-pcie-gadget.txt~st-spear-pcie-gadget-documentation-for-support-of-multiple-device
+++ a/Documentation/misc-devices/spear-pcie-gadget.txt
@@ -66,7 +66,8 @@ Node programming example
 Program all PCIe registers in such a way that when this device is connected
 to the PCIe host, then host sees this device as 1MB RAM.
 #mount -t configfs none /Config
-# cd /config/pcie_gadget/
+For nth PCIe Device Controller
+# cd /config/pcie_gadget.n/
 Now you have all the nodes in this directory.
 program vendor id as 0x104a
 # echo 104A >> vendor_id
_

Patches currently in -mm which might be from pratyush.anand@st.com are

st-spear-pcie-gadget-suppport.patch
st-spear-pcie-gadget-documentation-for-support-of-multiple-device.patch

