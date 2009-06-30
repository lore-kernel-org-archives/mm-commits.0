From: akpm@linux-foundation.org
Subject: + vt6655-s-void-void.patch added to -mm tree
Date: Tue, 30 Jun 2009 12:42:50 -0700
Message-ID: <200906301942.n5UJgoPP003781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753065AbZF3Tnk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jun 2009 15:43:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.beregalov@gmail.com, forest@alittletooquiet.net, greg@kroah.com


The patch titled
     vt6655: s/VOID/void/
has been added to the -mm tree.  Its filename is
     vt6655-s-void-void.patch

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
Subject: vt6655: s/VOID/void/
From: Alexander Beregalov <a.beregalov@gmail.com>

Cc: Forest Bond <forest@alittletooquiet.net>
Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/vt6655/80211mgr.c    |   44 +++++------
 drivers/staging/vt6655/80211mgr.h    |   44 +++++------
 drivers/staging/vt6655/baseband.c    |   34 ++++-----
 drivers/staging/vt6655/baseband.h    |   26 +++---
 drivers/staging/vt6655/bssdb.c       |   30 +++----
 drivers/staging/vt6655/bssdb.h       |   18 ++--
 drivers/staging/vt6655/card.c        |   24 +++---
 drivers/staging/vt6655/card.h        |   18 ++--
 drivers/staging/vt6655/datarate.c    |    8 +-
 drivers/staging/vt6655/datarate.h    |    4 -
 drivers/staging/vt6655/device.h      |    4 -
 drivers/staging/vt6655/device_cfg.h  |   12 ---
 drivers/staging/vt6655/device_main.c |    6 -
 drivers/staging/vt6655/dpc.c         |   10 +-
 drivers/staging/vt6655/dpc.h         |    2 
 drivers/staging/vt6655/ioctl.c       |    2 
 drivers/staging/vt6655/ioctl.h       |    2 
 drivers/staging/vt6655/key.c         |    8 +-
 drivers/staging/vt6655/key.h         |    6 -
 drivers/staging/vt6655/mac.c         |    8 +-
 drivers/staging/vt6655/mac.h         |   52 ++++++-------
 drivers/staging/vt6655/michael.c     |   24 +++---
 drivers/staging/vt6655/michael.h     |    8 +-
 drivers/staging/vt6655/power.c       |    6 -
 drivers/staging/vt6655/power.h       |    6 -
 drivers/staging/vt6655/rc4.c         |    4 -
 drivers/staging/vt6655/rc4.h         |    2 
 drivers/staging/vt6655/rf.c          |    2 
 drivers/staging/vt6655/rf.h          |    2 
 drivers/staging/vt6655/rxtx.c        |   24 +++---
 drivers/staging/vt6655/rxtx.h        |   10 +-
 drivers/staging/vt6655/srom.h        |    2 
 drivers/staging/vt6655/tkip.c        |    2 
 drivers/staging/vt6655/tkip.h        |    2 
 drivers/staging/vt6655/ttype.h       |   12 ---
 drivers/staging/vt6655/vntwifi.c     |   20 ++---
 drivers/staging/vt6655/vntwifi.h     |   20 ++---
 drivers/staging/vt6655/wcmd.c        |   12 +--
 drivers/staging/vt6655/wcmd.h        |    8 +-
 drivers/staging/vt6655/wmgr.c        |   94 ++++++++++++-------------
 drivers/staging/vt6655/wmgr.h        |   20 ++---
 drivers/staging/vt6655/wpa.c         |    4 -
 drivers/staging/vt6655/wpa.h         |    4 -
 drivers/staging/vt6655/wpa2.c        |    4 -
 drivers/staging/vt6655/wpa2.h        |    4 -
 45 files changed, 317 insertions(+), 341 deletions(-)

diff -puN drivers/staging/vt6655/80211mgr.c~vt6655-s-void-void drivers/staging/vt6655/80211mgr.c
--- a/drivers/staging/vt6655/80211mgr.c~vt6655-s-void-void
+++ a/drivers/staging/vt6655/80211mgr.c
@@ -106,7 +106,7 @@ static int          msglevel            
  *
 -*/
 
-VOID
+void
 vMgrEncodeBeacon(
     IN  PWLAN_FR_BEACON  pFrame
      )
@@ -138,7 +138,7 @@ vMgrEncodeBeacon(
 -*/
 
 
-VOID
+void
 vMgrDecodeBeacon(
     IN  PWLAN_FR_BEACON  pFrame
     )
@@ -259,7 +259,7 @@ vMgrDecodeBeacon(
 -*/
 
 
-VOID
+void
 vMgrEncodeIBSSATIM(
     IN  PWLAN_FR_IBSSATIM   pFrame
     )
@@ -282,7 +282,7 @@ vMgrEncodeIBSSATIM(
  *
 -*/
 
-VOID
+void
 vMgrDecodeIBSSATIM(
     IN  PWLAN_FR_IBSSATIM   pFrame
     )
@@ -304,7 +304,7 @@ vMgrDecodeIBSSATIM(
  *
 -*/
 
-VOID
+void
 vMgrEncodeDisassociation(
     IN  PWLAN_FR_DISASSOC  pFrame
     )
@@ -332,7 +332,7 @@ vMgrEncodeDisassociation(
  *
 -*/
 
-VOID
+void
 vMgrDecodeDisassociation(
     IN  PWLAN_FR_DISASSOC  pFrame
     )
@@ -358,7 +358,7 @@ vMgrDecodeDisassociation(
 -*/
 
 
-VOID
+void
 vMgrEncodeAssocRequest(
     IN  PWLAN_FR_ASSOCREQ  pFrame
     )
@@ -385,7 +385,7 @@ vMgrEncodeAssocRequest(
  *
 -*/
 
-VOID
+void
 vMgrDecodeAssocRequest(
     IN  PWLAN_FR_ASSOCREQ  pFrame
     )
@@ -451,7 +451,7 @@ vMgrDecodeAssocRequest(
  *
 -*/
 
-VOID
+void
 vMgrEncodeAssocResponse(
     IN  PWLAN_FR_ASSOCRESP  pFrame
      )
@@ -483,7 +483,7 @@ vMgrEncodeAssocResponse(
  *
 -*/
 
-VOID
+void
 vMgrDecodeAssocResponse(
     IN PWLAN_FR_ASSOCRESP  pFrame
      )
@@ -529,7 +529,7 @@ vMgrDecodeAssocResponse(
  *
 -*/
 
-VOID
+void
 vMgrEncodeReassocRequest(
     IN  PWLAN_FR_REASSOCREQ  pFrame
      )
@@ -561,7 +561,7 @@ vMgrEncodeReassocRequest(
 -*/
 
 
-VOID
+void
 vMgrDecodeReassocRequest(
     IN  PWLAN_FR_REASSOCREQ  pFrame
      )
@@ -633,7 +633,7 @@ vMgrDecodeReassocRequest(
 -*/
 
 
-VOID
+void
 vMgrEncodeProbeRequest(
     IN PWLAN_FR_PROBEREQ  pFrame
      )
@@ -654,7 +654,7 @@ vMgrEncodeProbeRequest(
  *
 -*/
 
-VOID
+void
 vMgrDecodeProbeRequest(
     IN PWLAN_FR_PROBEREQ  pFrame
      )
@@ -707,7 +707,7 @@ vMgrDecodeProbeRequest(
 -*/
 
 
-VOID
+void
 vMgrEncodeProbeResponse(
     IN PWLAN_FR_PROBERESP  pFrame
     )
@@ -741,7 +741,7 @@ vMgrEncodeProbeResponse(
  *
 -*/
 
-VOID
+void
 vMgrDecodeProbeResponse(
     IN PWLAN_FR_PROBERESP  pFrame
     )
@@ -862,7 +862,7 @@ vMgrDecodeProbeResponse(
  *
 -*/
 
-VOID
+void
 vMgrEncodeAuthen(
     IN  PWLAN_FR_AUTHEN  pFrame
     )
@@ -893,7 +893,7 @@ vMgrEncodeAuthen(
  *
 -*/
 
-VOID
+void
 vMgrDecodeAuthen(
     IN  PWLAN_FR_AUTHEN  pFrame
     )
@@ -933,7 +933,7 @@ vMgrDecodeAuthen(
  *
 -*/
 
-VOID
+void
 vMgrEncodeDeauthen(
     IN  PWLAN_FR_DEAUTHEN  pFrame
     )
@@ -960,7 +960,7 @@ vMgrEncodeDeauthen(
  *
 -*/
 
-VOID
+void
 vMgrDecodeDeauthen(
     IN  PWLAN_FR_DEAUTHEN  pFrame
     )
@@ -986,7 +986,7 @@ vMgrDecodeDeauthen(
  *
 -*/
 
-VOID
+void
 vMgrEncodeReassocResponse(
     IN  PWLAN_FR_REASSOCRESP  pFrame
      )
@@ -1019,7 +1019,7 @@ vMgrEncodeReassocResponse(
 -*/
 
 
-VOID
+void
 vMgrDecodeReassocResponse(
     IN  PWLAN_FR_REASSOCRESP  pFrame
      )
diff -puN drivers/staging/vt6655/80211mgr.h~vt6655-s-void-void drivers/staging/vt6655/80211mgr.h
--- a/drivers/staging/vt6655/80211mgr.h~vt6655-s-void-void
+++ a/drivers/staging/vt6655/80211mgr.h
@@ -719,112 +719,112 @@ typedef struct tagWLAN_FR_DEAUTHEN {
 } WLAN_FR_DEAUTHEN, *PWLAN_FR_DEAUTHEN;
 
 /*---------------------  Export Functions  --------------------------*/
-VOID
+void
 vMgrEncodeBeacon(
     IN  PWLAN_FR_BEACON  pFrame
      );
 
-VOID
+void
 vMgrDecodeBeacon(
     IN  PWLAN_FR_BEACON  pFrame
     );
 
-VOID
+void
 vMgrEncodeIBSSATIM(
     IN  PWLAN_FR_IBSSATIM   pFrame
     );
 
-VOID
+void
 vMgrDecodeIBSSATIM(
     IN  PWLAN_FR_IBSSATIM   pFrame
     );
 
-VOID
+void
 vMgrEncodeDisassociation(
     IN  PWLAN_FR_DISASSOC  pFrame
     );
 
-VOID
+void
 vMgrDecodeDisassociation(
     IN  PWLAN_FR_DISASSOC  pFrame
     );
 
-VOID
+void
 vMgrEncodeAssocRequest(
     IN  PWLAN_FR_ASSOCREQ  pFrame
     );
 
-VOID
+void
 vMgrDecodeAssocRequest(
     IN  PWLAN_FR_ASSOCREQ  pFrame
     );
 
-VOID
+void
 vMgrEncodeAssocResponse(
     IN  PWLAN_FR_ASSOCRESP  pFrame
     );
 
-VOID
+void
 vMgrDecodeAssocResponse(
     IN PWLAN_FR_ASSOCRESP  pFrame
     );
 
-VOID
+void
 vMgrEncodeReassocRequest(
     IN  PWLAN_FR_REASSOCREQ  pFrame
     );
 
-VOID
+void
 vMgrDecodeReassocRequest(
     IN  PWLAN_FR_REASSOCREQ  pFrame
     );
 
-VOID
+void
 vMgrEncodeProbeRequest(
     IN PWLAN_FR_PROBEREQ  pFrame
     );
 
-VOID
+void
 vMgrDecodeProbeRequest(
     IN PWLAN_FR_PROBEREQ  pFrame
     );
 
-VOID
+void
 vMgrEncodeProbeResponse(
     IN PWLAN_FR_PROBERESP  pFrame
     );
 
-VOID
+void
 vMgrDecodeProbeResponse(
     IN PWLAN_FR_PROBERESP  pFrame
     );
 
-VOID
+void
 vMgrEncodeAuthen(
     IN  PWLAN_FR_AUTHEN  pFrame
     );
 
-VOID
+void
 vMgrDecodeAuthen(
     IN  PWLAN_FR_AUTHEN  pFrame
     );
 
-VOID
+void
 vMgrEncodeDeauthen(
     IN  PWLAN_FR_DEAUTHEN  pFrame
     );
 
-VOID
+void
 vMgrDecodeDeauthen(
     IN  PWLAN_FR_DEAUTHEN  pFrame
     );
 
-VOID
+void
 vMgrEncodeReassocResponse(
     IN  PWLAN_FR_REASSOCRESP  pFrame
     );
 
-VOID
+void
 vMgrDecodeReassocResponse(
     IN  PWLAN_FR_REASSOCRESP  pFrame
     );
diff -puN drivers/staging/vt6655/baseband.c~vt6655-s-void-void drivers/staging/vt6655/baseband.c
--- a/drivers/staging/vt6655/baseband.c~vt6655-s-void-void
+++ a/drivers/staging/vt6655/baseband.c
@@ -1737,13 +1737,13 @@ ULONG
 s_ulGetRatio(PSDevice pDevice);
 
 static
-VOID
+void
 s_vChangeAntenna(
     IN PSDevice pDevice
     );
 
 static
-VOID
+void
 s_vChangeAntenna (
     IN PSDevice pDevice
     )
@@ -1856,7 +1856,7 @@ BBuGetFrameTime (
  * Return Value: none
  *
  */
-VOID
+void
 BBvCaculateParameter (
     IN  PSDevice pDevice,
     IN  UINT cbFrameLength,
@@ -2334,7 +2334,7 @@ BOOL BBbVT3253Init (PSDevice pDevice)
  * Return Value: none
  *
  */
-VOID BBvReadAllRegs (DWORD_PTR dwIoBase, PBYTE pbyBBRegs)
+void BBvReadAllRegs (DWORD_PTR dwIoBase, PBYTE pbyBBRegs)
 {
     int  ii;
     BYTE byBase = 1;
@@ -2451,7 +2451,7 @@ void BBvLoopbackOff (PSDevice pDevice)
  * Return Value: none
  *
  */
-VOID
+void
 BBvSetShortSlotTime (PSDevice pDevice)
 {
     BYTE byBBRxConf=0;
@@ -2475,7 +2475,7 @@ BBvSetShortSlotTime (PSDevice pDevice)
 
 }
 
-VOID BBvSetVGAGainOffset(PSDevice pDevice, BYTE byData)
+void BBvSetVGAGainOffset(PSDevice pDevice, BYTE byData)
 {
     BYTE byBBRxConf=0;
 
@@ -2507,7 +2507,7 @@ VOID BBvSetVGAGainOffset(PSDevice pDevic
  * Return Value: none
  *
  */
-VOID
+void
 BBvSoftwareReset (DWORD_PTR dwIoBase)
 {
     BBbWriteEmbeded(dwIoBase, 0x50, 0x40);
@@ -2528,7 +2528,7 @@ BBvSoftwareReset (DWORD_PTR dwIoBase)
  * Return Value: none
  *
  */
-VOID
+void
 BBvPowerSaveModeON (DWORD_PTR dwIoBase)
 {
     BYTE byOrgData;
@@ -2550,7 +2550,7 @@ BBvPowerSaveModeON (DWORD_PTR dwIoBase)
  * Return Value: none
  *
  */
-VOID
+void
 BBvPowerSaveModeOFF (DWORD_PTR dwIoBase)
 {
     BYTE byOrgData;
@@ -2574,7 +2574,7 @@ BBvPowerSaveModeOFF (DWORD_PTR dwIoBase)
  *
  */
 
-VOID
+void
 BBvSetTxAntennaMode (DWORD_PTR dwIoBase, BYTE byAntennaMode)
 {
     BYTE byBBTxConf;
@@ -2616,7 +2616,7 @@ BBvSetTxAntennaMode (DWORD_PTR dwIoBase,
  *
  */
 
-VOID
+void
 BBvSetRxAntennaMode (DWORD_PTR dwIoBase, BYTE byAntennaMode)
 {
     BYTE byBBRxConf;
@@ -2647,14 +2647,14 @@ BBvSetRxAntennaMode (DWORD_PTR dwIoBase,
  * Return Value: none
  *
  */
-VOID
+void
 BBvSetDeepSleep (DWORD_PTR dwIoBase, BYTE byLocalID)
 {
     BBbWriteEmbeded(dwIoBase, 0x0C, 0x17);//CR12
     BBbWriteEmbeded(dwIoBase, 0x0D, 0xB9);//CR13
 }
 
-VOID
+void
 BBvExitDeepSleep (DWORD_PTR dwIoBase, BYTE byLocalID)
 {
     BBbWriteEmbeded(dwIoBase, 0x0C, 0x00);//CR12
@@ -2772,7 +2772,7 @@ ULONG   ulPacketNum;
 }
 
 
-VOID
+void
 BBvClearAntDivSQ3Value (PSDevice pDevice)
 {
     UINT    ii;
@@ -2799,7 +2799,7 @@ BBvClearAntDivSQ3Value (PSDevice pDevice
  *
  */
 
-VOID
+void
 BBvAntennaDiversity (PSDevice pDevice, BYTE byRxRate, BYTE bySQ3)
 {
 
@@ -2889,7 +2889,7 @@ BBvAntennaDiversity (PSDevice pDevice, B
  *
 -*/
 
-VOID
+void
 TimerSQ3CallBack (
     IN  HANDLE      hDeviceContext
     )
@@ -2939,7 +2939,7 @@ TimerSQ3CallBack (
  *
 -*/
 
-VOID
+void
 TimerState1CallBack (
     IN  HANDLE      hDeviceContext
     )
diff -puN drivers/staging/vt6655/baseband.h~vt6655-s-void-void drivers/staging/vt6655/baseband.h
--- a/drivers/staging/vt6655/baseband.h~vt6655-s-void-void
+++ a/drivers/staging/vt6655/baseband.h
@@ -140,7 +140,7 @@ BBuGetFrameTime(
     IN WORD wRate
     );
 
-VOID
+void
 BBvCaculateParameter (
     IN  PSDevice pDevice,
     IN  UINT cbFrameLength,
@@ -154,36 +154,36 @@ BBvCaculateParameter (
 BOOL BBbReadEmbeded(DWORD_PTR dwIoBase, BYTE byBBAddr, PBYTE pbyData);
 BOOL BBbWriteEmbeded(DWORD_PTR dwIoBase, BYTE byBBAddr, BYTE byData);
 
-VOID BBvReadAllRegs(DWORD_PTR dwIoBase, PBYTE pbyBBRegs);
+void BBvReadAllRegs(DWORD_PTR dwIoBase, PBYTE pbyBBRegs);
 void BBvLoopbackOn(PSDevice pDevice);
 void BBvLoopbackOff(PSDevice pDevice);
 void BBvSetShortSlotTime(PSDevice pDevice);
 BOOL BBbIsRegBitsOn(DWORD_PTR dwIoBase, BYTE byBBAddr, BYTE byTestBits);
 BOOL BBbIsRegBitsOff(DWORD_PTR dwIoBase, BYTE byBBAddr, BYTE byTestBits);
-VOID BBvSetVGAGainOffset(PSDevice pDevice, BYTE byData);
+void BBvSetVGAGainOffset(PSDevice pDevice, BYTE byData);
 
 // VT3253 Baseband
 BOOL BBbVT3253Init(PSDevice pDevice);
-VOID BBvSoftwareReset(DWORD_PTR dwIoBase);
-VOID BBvPowerSaveModeON(DWORD_PTR dwIoBase);
-VOID BBvPowerSaveModeOFF(DWORD_PTR dwIoBase);
-VOID BBvSetTxAntennaMode(DWORD_PTR dwIoBase, BYTE byAntennaMode);
-VOID BBvSetRxAntennaMode(DWORD_PTR dwIoBase, BYTE byAntennaMode);
-VOID BBvSetDeepSleep(DWORD_PTR dwIoBase, BYTE byLocalID);
-VOID BBvExitDeepSleep(DWORD_PTR dwIoBase, BYTE byLocalID);
+void BBvSoftwareReset(DWORD_PTR dwIoBase);
+void BBvPowerSaveModeON(DWORD_PTR dwIoBase);
+void BBvPowerSaveModeOFF(DWORD_PTR dwIoBase);
+void BBvSetTxAntennaMode(DWORD_PTR dwIoBase, BYTE byAntennaMode);
+void BBvSetRxAntennaMode(DWORD_PTR dwIoBase, BYTE byAntennaMode);
+void BBvSetDeepSleep(DWORD_PTR dwIoBase, BYTE byLocalID);
+void BBvExitDeepSleep(DWORD_PTR dwIoBase, BYTE byLocalID);
 
 // timer for antenna diversity
-VOID
+void
 TimerSQ3CallBack(
     IN  HANDLE hDeviceContext
     );
-VOID
+void
 TimerState1CallBack(
     IN  HANDLE hDeviceContext
     );
 
 void BBvAntennaDiversity(PSDevice pDevice, BYTE byRxRate, BYTE bySQ3);
-VOID
+void
 BBvClearAntDivSQ3Value (PSDevice pDevice);
 
 
diff -puN drivers/staging/vt6655/bssdb.c~vt6655-s-void-void drivers/staging/vt6655/bssdb.c
--- a/drivers/staging/vt6655/bssdb.c~vt6655-s-void-void
+++ a/drivers/staging/vt6655/bssdb.c
@@ -132,18 +132,18 @@ const WORD             awHWRetry1[5][5] 
 
 /*---------------------  Static Functions  --------------------------*/
 
-VOID s_vCheckSensitivity(
+void s_vCheckSensitivity(
     IN HANDLE hDeviceContext
     );
 
 #ifdef Calcu_LinkQual
-VOID s_uCalculateLinkQual(
+void s_uCalculateLinkQual(
     IN HANDLE hDeviceContext
     );
 #endif
 
 
-VOID s_vCheckPreEDThreshold(
+void s_vCheckPreEDThreshold(
     IN HANDLE hDeviceContext
     );
 /*---------------------  Export Variables  --------------------------*/
@@ -322,7 +322,7 @@ if(pDevice->bLinkPass==FALSE) pCurrBSS->
 -*/
 
 
-VOID
+void
 BSSvClearBSSList(
     IN HANDLE hDeviceContext,
     IN BOOL bKeepCurrBSSID
@@ -841,7 +841,7 @@ BSSDBbIsSTAInNodeDB(
  *    None
  *
 -*/
-VOID
+void
 BSSvCreateOneNode(
     IN HANDLE hDeviceContext,
     OUT PUINT puNodeIndex
@@ -906,7 +906,7 @@ BSSvCreateOneNode(
  *    None
  *
 -*/
-VOID
+void
 BSSvRemoveOneNode(
     IN HANDLE hDeviceContext,
     IN UINT uNodeIndex
@@ -939,7 +939,7 @@ BSSvRemoveOneNode(
  *
 -*/
 
-VOID
+void
 BSSvUpdateAPNode(
     IN HANDLE hDeviceContext,
     IN PWORD pwCapInfo,
@@ -1002,7 +1002,7 @@ BSSvUpdateAPNode(
 -*/
 
 
-VOID
+void
 BSSvAddMulticastNode(
     IN HANDLE hDeviceContext
     )
@@ -1055,7 +1055,7 @@ BSSvAddMulticastNode(
 BOOL cc=FALSE;
 UINT status;
 #endif
-VOID
+void
 BSSvSecondCallBack(
     IN  HANDLE hDeviceContext
     )
@@ -1432,7 +1432,7 @@ start:
 
 
 
-VOID
+void
 BSSvUpdateNodeTxCounter(
     IN HANDLE      hDeviceContext,
     IN BYTE        byTsr0,
@@ -1624,7 +1624,7 @@ BSSvUpdateNodeTxCounter(
 -*/
 
 
-VOID
+void
 BSSvClearNodeDBTable(
     IN HANDLE hDeviceContext,
     IN UINT uStartIndex
@@ -1653,7 +1653,7 @@ BSSvClearNodeDBTable(
 };
 
 
-VOID s_vCheckSensitivity(
+void s_vCheckSensitivity(
     IN HANDLE hDeviceContext
     )
 {
@@ -1702,7 +1702,7 @@ VOID s_vCheckSensitivity(
 }
 
 
-VOID
+void
 BSSvClearAnyBSSJoinRecord (
     IN HANDLE hDeviceContext
     )
@@ -1718,7 +1718,7 @@ BSSvClearAnyBSSJoinRecord (
 }
 
 #ifdef Calcu_LinkQual
-VOID s_uCalculateLinkQual(
+void s_uCalculateLinkQual(
     IN HANDLE hDeviceContext
     )
 {
@@ -1766,7 +1766,7 @@ else
 }
 #endif
 
-VOID s_vCheckPreEDThreshold(
+void s_vCheckPreEDThreshold(
     IN HANDLE hDeviceContext
     )
 {
diff -puN drivers/staging/vt6655/bssdb.h~vt6655-s-void-void drivers/staging/vt6655/bssdb.h
--- a/drivers/staging/vt6655/bssdb.h~vt6655-s-void-void
+++ a/drivers/staging/vt6655/bssdb.h
@@ -267,7 +267,7 @@ BSSpAddrIsInBSSList(
     IN PWLAN_IE_SSID pSSID
     );
 
-VOID
+void
 BSSvClearBSSList(
     IN HANDLE hDeviceContext,
     IN BOOL bKeepCurrBSSID
@@ -325,13 +325,13 @@ BSSDBbIsSTAInNodeDB(
     OUT PUINT puNodeIndex
     );
 
-VOID
+void
 BSSvCreateOneNode(
     IN HANDLE hDeviceContext,
     OUT PUINT puNodeIndex
     );
 
-VOID
+void
 BSSvUpdateAPNode(
     IN HANDLE hDeviceContext,
     IN PWORD pwCapInfo,
@@ -340,12 +340,12 @@ BSSvUpdateAPNode(
     );
 
 
-VOID
+void
 BSSvSecondCallBack(
     IN HANDLE hDeviceContext
     );
 
-VOID
+void
 BSSvUpdateNodeTxCounter(
     IN HANDLE hDeviceContext,
     IN BYTE        byTsr0,
@@ -354,25 +354,25 @@ BSSvUpdateNodeTxCounter(
     IN UINT        uFIFOHeaderSize
     );
 
-VOID
+void
 BSSvRemoveOneNode(
     IN HANDLE hDeviceContext,
     IN UINT uNodeIndex
     );
 
-VOID
+void
 BSSvAddMulticastNode(
     IN HANDLE hDeviceContext
     );
 
 
-VOID
+void
 BSSvClearNodeDBTable(
     IN HANDLE hDeviceContext,
     IN UINT uStartIndex
     );
 
-VOID
+void
 BSSvClearAnyBSSJoinRecord(
     IN HANDLE hDeviceContext
     );
diff -puN drivers/staging/vt6655/card.c~vt6655-s-void-void drivers/staging/vt6655/card.c
--- a/drivers/staging/vt6655/card.c~vt6655-s-void-void
+++ a/drivers/staging/vt6655/card.c
@@ -453,7 +453,7 @@ SCountryTable ChannelRuleTab[CCODE_MAX+1
 /*---------------------  Static Functions  --------------------------*/
 
 static
-VOID
+void
 s_vCaculateOFDMRParameter(
     IN  BYTE byRate,
     IN  CARD_PHY_TYPE ePHYType,
@@ -526,7 +526,7 @@ exit:
  *
  */
 static
-VOID
+void
 s_vCaculateOFDMRParameter (
     IN  BYTE byRate,
     IN  CARD_PHY_TYPE ePHYType,
@@ -641,7 +641,7 @@ s_vCaculateOFDMRParameter (
  *
  */
 static
-VOID
+void
 s_vSetRSPINF (PSDevice pDevice, CARD_PHY_TYPE ePHYType, PVOID pvSupportRateIEs, PVOID pvExtSupportRateIEs)
 {
     BYTE  byServ = 0, bySignal = 0; // For CCK
@@ -1641,7 +1641,7 @@ CARDpGetCurrentAddress (
 
 
 
-VOID CARDvInitChannelTable (PVOID pDeviceHandler)
+void CARDvInitChannelTable (PVOID pDeviceHandler)
 {
     PSDevice    pDevice = (PSDevice) pDeviceHandler;
     BOOL        bMultiBand = FALSE;
@@ -2063,7 +2063,7 @@ CARDbStartQuiet (
  * Return Value: none.
  *
 -*/
-VOID
+void
 CARDvSetCountryInfo (
     IN PVOID            pDeviceHandler,
     IN CARD_PHY_TYPE    ePHYType,
@@ -2122,7 +2122,7 @@ CARDvSetCountryInfo (
  * Return Value: none.
  *
 -*/
-VOID
+void
 CARDvSetPowerConstraint (
     IN PVOID            pDeviceHandler,
     IN BYTE             byChannel,
@@ -2157,7 +2157,7 @@ CARDvSetPowerConstraint (
  * Return Value: none.
  *
 -*/
-VOID
+void
 CARDvGetPowerCapability (
     IN PVOID            pDeviceHandler,
     OUT PBYTE           pbyMinPower,
@@ -2309,7 +2309,7 @@ CARDbChannelGetList (
 }
 
 
-VOID
+void
 CARDvSetCountryIE(
     IN PVOID        pDeviceHandler,
     IN PVOID        pIE
@@ -2354,7 +2354,7 @@ CARDbGetChannelMapInfo(
 }
 
 
-VOID
+void
 CARDvSetChannelMapInfo(
     IN PVOID        pDeviceHandler,
     IN UINT         uChannelIndex,
@@ -2370,7 +2370,7 @@ CARDvSetChannelMapInfo(
 }
 
 
-VOID
+void
 CARDvClearChannelMapInfo(
     IN PVOID        pDeviceHandler
     )
@@ -2450,7 +2450,7 @@ CARDbyAutoChannelSelect(
 
 
 //xxx
-VOID
+void
 CARDvSafeResetTx (
     IN PVOID    pDeviceHandler
     )
@@ -2506,7 +2506,7 @@ CARDvSafeResetTx (
  * Return Value: none
  *
 -*/
-VOID
+void
 CARDvSafeResetRx (
     IN PVOID    pDeviceHandler
     )
diff -puN drivers/staging/vt6655/card.h~vt6655-s-void-void drivers/staging/vt6655/card.h
--- a/drivers/staging/vt6655/card.h~vt6655-s-void-void
+++ a/drivers/staging/vt6655/card.h
@@ -113,8 +113,8 @@ QWORD CARDqGetNextTBTT(QWORD qwTSF, WORD
 QWORD CARDqGetTSFOffset(BYTE byRxRate, QWORD qwTSF1, QWORD qwTSF2);
 BOOL CARDbSetTxPower(PVOID pDeviceHandler, ULONG ulTxPower);
 BYTE CARDbyGetPktType(PVOID pDeviceHandler);
-VOID CARDvSafeResetTx(PVOID pDeviceHandler);
-VOID CARDvSafeResetRx(PVOID pDeviceHandler);
+void CARDvSafeResetTx(PVOID pDeviceHandler);
+void CARDvSafeResetRx(PVOID pDeviceHandler);
 
 //xxx
 BOOL CARDbRadioPowerOff(PVOID pDeviceHandler);
@@ -157,7 +157,7 @@ CARDpGetCurrentAddress (
     );
 
 
-VOID CARDvInitChannelTable(PVOID pDeviceHandler);
+void CARDvInitChannelTable(PVOID pDeviceHandler);
 BYTE CARDbyGetChannelMapping(PVOID pDeviceHandler, BYTE byChannelNumber, CARD_PHY_TYPE ePhyType);
 
 BOOL
@@ -190,21 +190,21 @@ CARDbStartQuiet (
     IN PVOID            pDeviceHandler
     );
 
-VOID
+void
 CARDvSetCountryInfo (
     IN PVOID            pDeviceHandler,
     IN CARD_PHY_TYPE    ePHYType,
     IN PVOID            pIE
     );
 
-VOID
+void
 CARDvSetPowerConstraint (
     IN PVOID            pDeviceHandler,
     IN BYTE             byChannel,
     IN I8               byPower
     );
 
-VOID
+void
 CARDvGetPowerCapability (
     IN PVOID            pDeviceHandler,
     OUT PBYTE           pbyMinPower,
@@ -228,7 +228,7 @@ CARDbChannelGetList (
     OUT PBYTE      pbyChannelTable
     );
 
-VOID
+void
 CARDvSetCountryIE(
     IN PVOID        pDeviceHandler,
     IN PVOID        pIE
@@ -242,14 +242,14 @@ CARDbGetChannelMapInfo(
     OUT PBYTE       pbyMap
     );
 
-VOID
+void
 CARDvSetChannelMapInfo(
     IN PVOID        pDeviceHandler,
     IN UINT         uChannelIndex,
     IN BYTE         byMap
     );
 
-VOID
+void
 CARDvClearChannelMapInfo(
     IN PVOID        pDeviceHandler
     );
diff -puN drivers/staging/vt6655/datarate.c~vt6655-s-void-void drivers/staging/vt6655/datarate.c
--- a/drivers/staging/vt6655/datarate.c~vt6655-s-void-void
+++ a/drivers/staging/vt6655/datarate.c
@@ -82,13 +82,13 @@ const BYTE acbyIERate[MAX_RATE] =
 
 /*---------------------  Static Functions  --------------------------*/
 
-VOID s_vResetCounter (
+void s_vResetCounter (
     IN PKnownNodeDB psNodeDBTable
     );
 
 
 
-VOID
+void
 s_vResetCounter (
     IN PKnownNodeDB psNodeDBTable
     )
@@ -212,7 +212,7 @@ wGetRateIdx(
  * Return Value: none
  *
 -*/
-VOID
+void
 RATEvParseMaxRate (
     IN PVOID pDeviceHandler,
     IN PWLAN_IE_SUPP_RATES pItemRates,
@@ -325,7 +325,7 @@ UINT  uRateLen;
 #define AUTORATE_TXCNT_THRESHOLD        20
 #define AUTORATE_INC_THRESHOLD          30
 
-VOID
+void
 RATEvTxRateFallBack (
     IN PVOID pDeviceHandler,
     IN PKnownNodeDB psNodeDBTable
diff -puN drivers/staging/vt6655/datarate.h~vt6655-s-void-void drivers/staging/vt6655/datarate.h
--- a/drivers/staging/vt6655/datarate.h~vt6655-s-void-void
+++ a/drivers/staging/vt6655/datarate.h
@@ -54,7 +54,7 @@
 
 
 
-VOID
+void
 RATEvParseMaxRate(
     IN PVOID pDeviceHandler,
     IN PWLAN_IE_SUPP_RATES pItemRates,
@@ -67,7 +67,7 @@ RATEvParseMaxRate(
     OUT PBYTE pbyTopOFDMRate
     );
 
-VOID
+void
 RATEvTxRateFallBack(
     IN PVOID pDeviceHandler,
     IN PKnownNodeDB psNodeDBTable
diff -puN drivers/staging/vt6655/device.h~vt6655-s-void-void drivers/staging/vt6655/device.h
--- a/drivers/staging/vt6655/device.h~vt6655-s-void-void
+++ a/drivers/staging/vt6655/device.h
@@ -961,7 +961,7 @@ typedef struct __device_info {
 //PLICE_DEBUG->
 
 
- inline  static	VOID   EnQueue (PSDevice pDevice,PSRxMgmtPacket  pRxMgmtPacket)
+ inline  static	void   EnQueue (PSDevice pDevice,PSRxMgmtPacket  pRxMgmtPacket)
 {
 	//printk("Enter EnQueue:tail is %d\n",pDevice->rxManeQueue.tail);
 	if ((pDevice->rxManeQueue.tail+1) % NUM == pDevice->rxManeQueue.head)
@@ -1002,7 +1002,7 @@ typedef struct __device_info {
 	}
 }
 
-VOID	InitRxManagementQueue(PSDevice   pDevice);
+void	InitRxManagementQueue(PSDevice   pDevice);
 
 
 
diff -puN drivers/staging/vt6655/device_cfg.h~vt6655-s-void-void drivers/staging/vt6655/device_cfg.h
--- a/drivers/staging/vt6655/device_cfg.h~vt6655-s-void-void
+++ a/drivers/staging/vt6655/device_cfg.h
@@ -41,18 +41,6 @@ typedef __u16   UINT16,  *PUINT16;
 typedef __u32   UINT32,  *PUINT32;
 
 
-#ifndef VOID
-#define VOID            void
-#endif
-
-#ifndef CONST
-#define CONST           const
-#endif
-
-#ifndef STATIC
-#define STATIC          static
-#endif
-
 #ifndef DEF
 #define DEF
 #endif
diff -puN drivers/staging/vt6655/device_main.c~vt6655-s-void-void drivers/staging/vt6655/device_main.c
--- a/drivers/staging/vt6655/device_main.c~vt6655-s-void-void
+++ a/drivers/staging/vt6655/device_main.c
@@ -544,7 +544,7 @@ pDevice->bUpdateBBVGA = TRUE;
     DEVICE_PRT(MSG_LEVEL_DEBUG, KERN_INFO" pDevice->bDiversityRegCtlON= %d\n",(INT)pDevice->bDiversityRegCtlON);
 }
 
-static VOID s_vCompleteCurrentMeasure (IN PSDevice pDevice, IN BYTE byResult)
+static void s_vCompleteCurrentMeasure (IN PSDevice pDevice, IN BYTE byResult)
 {
     UINT    ii;
     DWORD   dwDuration = 0;
@@ -912,7 +912,7 @@ else  CARDbRadioPowerOn(pDevice);
 
 
 
-static VOID device_init_diversity_timer(PSDevice pDevice) {
+static void device_init_diversity_timer(PSDevice pDevice) {
 
     init_timer(&pDevice->TimerSQ3Tmax1);
     pDevice->TimerSQ3Tmax1.data = (ULONG)pDevice;
@@ -1940,7 +1940,7 @@ static void device_free_tx_buf(PSDevice 
 
 
 //PLICE_DEBUG ->
-VOID	InitRxManagementQueue(PSDevice  pDevice)
+void	InitRxManagementQueue(PSDevice  pDevice)
 {
 	pDevice->rxManeQueue.packet_num = 0;
 	pDevice->rxManeQueue.head = pDevice->rxManeQueue.tail = 0;
diff -puN drivers/staging/vt6655/dpc.c~vt6655-s-void-void drivers/staging/vt6655/dpc.c
--- a/drivers/staging/vt6655/dpc.c~vt6655-s-void-void
+++ a/drivers/staging/vt6655/dpc.c
@@ -119,7 +119,7 @@ static BYTE s_byGetRateIdx(IN BYTE byRat
 
 
 static
-VOID
+void
 s_vGetDASA(
     IN  PBYTE pbyRxBufferAddr,
     OUT PUINT pcbHeaderSize,
@@ -127,7 +127,7 @@ s_vGetDASA(
     );
 
 static
-VOID
+void
 s_vProcessRxMACHeader (
     IN  PSDevice pDevice,
     IN  PBYTE pbyRxBufferAddr,
@@ -213,7 +213,7 @@ static BOOL s_bHostWepRxEncryption(
  *
 -*/
 static
-VOID
+void
 s_vProcessRxMACHeader (
     IN  PSDevice pDevice,
     IN  PBYTE pbyRxBufferAddr,
@@ -312,7 +312,7 @@ static BYTE s_byGetRateIdx (IN BYTE byRa
 
 
 static
-VOID
+void
 s_vGetDASA (
     IN  PBYTE pbyRxBufferAddr,
     OUT PUINT pcbHeaderSize,
@@ -364,7 +364,7 @@ s_vGetDASA (
 
 //PLICE_DEBUG ->
 
-VOID	MngWorkItem(PVOID Context)
+void	MngWorkItem(PVOID Context)
 {
 	PSRxMgmtPacket			pRxMgmtPacket;
 	PSDevice	pDevice =  (PSDevice) Context;
diff -puN drivers/staging/vt6655/dpc.h~vt6655-s-void-void drivers/staging/vt6655/dpc.h
--- a/drivers/staging/vt6655/dpc.h~vt6655-s-void-void
+++ a/drivers/staging/vt6655/dpc.h
@@ -68,7 +68,7 @@ device_receive_frame (
 
 
 
-VOID	MngWorkItem(PVOID Context);
+void	MngWorkItem(PVOID Context);
 #endif // __RXTX_H__
 
 
diff -puN drivers/staging/vt6655/ioctl.c~vt6655-s-void-void drivers/staging/vt6655/ioctl.c
--- a/drivers/staging/vt6655/ioctl.c~vt6655-s-void-void
+++ a/drivers/staging/vt6655/ioctl.c
@@ -737,7 +737,7 @@ int private_ioctl(PSDevice pDevice, stru
 }
 
 /*
-VOID
+void
 vConfigWEPKey (
     IN PSDevice pDevice,
     IN DWORD    dwKeyIndex,
diff -puN drivers/staging/vt6655/ioctl.h~vt6655-s-void-void drivers/staging/vt6655/ioctl.h
--- a/drivers/staging/vt6655/ioctl.h~vt6655-s-void-void
+++ a/drivers/staging/vt6655/ioctl.h
@@ -53,7 +53,7 @@ extern "C" {                            
 int private_ioctl(PSDevice pDevice, struct ifreq *rq);
 
 /*
-VOID vConfigWEPKey (
+void vConfigWEPKey (
     IN PSDevice pDevice,
     IN DWORD    dwKeyIndex,
     IN PBYTE    pbyKey,
diff -puN drivers/staging/vt6655/key.c~vt6655-s-void-void drivers/staging/vt6655/key.c
--- a/drivers/staging/vt6655/key.c~vt6655-s-void-void
+++ a/drivers/staging/vt6655/key.c
@@ -72,7 +72,7 @@ static int          msglevel            
 /*---------------------  Static Variables  --------------------------*/
 
 /*---------------------  Static Functions  --------------------------*/
-static VOID
+static void
 s_vCheckKeyTableValid (PSKeyManagement pTable, DWORD_PTR dwIoBase)
 {
     int i;
@@ -109,7 +109,7 @@ s_vCheckKeyTableValid (PSKeyManagement p
  * Return Value: none
  *
  */
-VOID KeyvInitTable (PSKeyManagement pTable, DWORD_PTR dwIoBase)
+void KeyvInitTable (PSKeyManagement pTable, DWORD_PTR dwIoBase)
 {
     int i;
     int jj;
@@ -483,7 +483,7 @@ BOOL KeybRemoveAllKey (
  * Return Value: TRUE if success otherwise FALSE
  *
  */
-VOID KeyvRemoveWEPKey (
+void KeyvRemoveWEPKey (
     PSKeyManagement pTable,
     DWORD           dwKeyIndex,
     DWORD_PTR       dwIoBase
@@ -505,7 +505,7 @@ VOID KeyvRemoveWEPKey (
     return;
 }
 
-VOID KeyvRemoveAllWEPKey (
+void KeyvRemoveAllWEPKey (
     PSKeyManagement pTable,
     DWORD_PTR       dwIoBase
     )
diff -puN drivers/staging/vt6655/key.h~vt6655-s-void-void drivers/staging/vt6655/key.h
--- a/drivers/staging/vt6655/key.h~vt6655-s-void-void
+++ a/drivers/staging/vt6655/key.h
@@ -113,7 +113,7 @@ typedef struct tagSKeyManagement
 extern "C" {                            /* Assume C declarations for C++ */
 #endif /* __cplusplus */
 
-VOID KeyvInitTable(PSKeyManagement pTable, DWORD_PTR dwIoBase);
+void KeyvInitTable(PSKeyManagement pTable, DWORD_PTR dwIoBase);
 
 BOOL KeybGetKey(
     IN  PSKeyManagement pTable,
@@ -170,13 +170,13 @@ BOOL KeybRemoveAllKey(
     DWORD_PTR       dwIoBase
     );
 
-VOID KeyvRemoveWEPKey(
+void KeyvRemoveWEPKey(
     PSKeyManagement pTable,
     DWORD           dwKeyIndex,
     DWORD_PTR       dwIoBase
     );
 
-VOID KeyvRemoveAllWEPKey(
+void KeyvRemoveAllWEPKey(
     PSKeyManagement pTable,
     DWORD_PTR       dwIoBase
     );
diff -puN drivers/staging/vt6655/mac.c~vt6655-s-void-void drivers/staging/vt6655/mac.c
--- a/drivers/staging/vt6655/mac.c~vt6655-s-void-void
+++ a/drivers/staging/vt6655/mac.c
@@ -108,7 +108,7 @@ static int          msglevel            
  * Return Value: none
  *
  */
-VOID MACvReadAllRegs (DWORD_PTR dwIoBase, PBYTE pbyMacRegs)
+void MACvReadAllRegs (DWORD_PTR dwIoBase, PBYTE pbyMacRegs)
 {
     int ii;
 
@@ -239,7 +239,7 @@ BYTE MACbyReadMultiAddr (DWORD_PTR dwIoB
  * Return Value: none
  *
  */
-VOID MACvWriteMultiAddr (DWORD_PTR dwIoBase, UINT uByteIdx, BYTE byData)
+void MACvWriteMultiAddr (DWORD_PTR dwIoBase, UINT uByteIdx, BYTE byData)
 {
     MACvSelectPage1(dwIoBase);
     VNSvOutPortB(dwIoBase + MAC_REG_MAR0 + uByteIdx, byData);
@@ -681,7 +681,7 @@ void MACvSaveContext (DWORD_PTR dwIoBase
  * Return Value: none
  *
  */
-VOID MACvRestoreContext (DWORD_PTR dwIoBase, PBYTE pbyCxtBuf)
+void MACvRestoreContext (DWORD_PTR dwIoBase, PBYTE pbyCxtBuf)
 {
     int         ii;
 
@@ -1249,7 +1249,7 @@ void MACvSetCurrTXDescAddr (int iTxType,
  * Return Value: none
  *
  */
-VOID MACvTimer0MicroSDelay (DWORD_PTR dwIoBase, UINT uDelay)
+void MACvTimer0MicroSDelay (DWORD_PTR dwIoBase, UINT uDelay)
 {
 BYTE byValue;
 UINT uu,ii;
diff -puN drivers/staging/vt6655/mac.h~vt6655-s-void-void drivers/staging/vt6655/mac.h
--- a/drivers/staging/vt6655/mac.h~vt6655-s-void-void
+++ a/drivers/staging/vt6655/mac.h
@@ -1086,7 +1086,7 @@ extern "C" {                            
 #endif /* __cplusplus */
 
 extern WORD TxRate_iwconfig;//2008-5-8 <add> by chester
-VOID MACvReadAllRegs(DWORD_PTR dwIoBase, PBYTE pbyMacRegs);
+void MACvReadAllRegs(DWORD_PTR dwIoBase, PBYTE pbyMacRegs);
 
 BOOL MACbIsRegBitsOn(DWORD_PTR dwIoBase, BYTE byRegOfs, BYTE byTestBits);
 BOOL MACbIsRegBitsOff(DWORD_PTR dwIoBase, BYTE byRegOfs, BYTE byTestBits);
@@ -1094,32 +1094,32 @@ BOOL MACbIsRegBitsOff(DWORD_PTR dwIoBase
 BOOL MACbIsIntDisable(DWORD_PTR dwIoBase);
 
 BYTE MACbyReadMultiAddr(DWORD_PTR dwIoBase, UINT uByteIdx);
-VOID MACvWriteMultiAddr(DWORD_PTR dwIoBase, UINT uByteIdx, BYTE byData);
-VOID MACvSetMultiAddrByHash(DWORD_PTR dwIoBase, BYTE byHashIdx);
-VOID MACvResetMultiAddrByHash(DWORD_PTR dwIoBase, BYTE byHashIdx);
+void MACvWriteMultiAddr(DWORD_PTR dwIoBase, UINT uByteIdx, BYTE byData);
+void MACvSetMultiAddrByHash(DWORD_PTR dwIoBase, BYTE byHashIdx);
+void MACvResetMultiAddrByHash(DWORD_PTR dwIoBase, BYTE byHashIdx);
 
-VOID MACvSetRxThreshold(DWORD_PTR dwIoBase, BYTE byThreshold);
-VOID MACvGetRxThreshold(DWORD_PTR dwIoBase, PBYTE pbyThreshold);
+void MACvSetRxThreshold(DWORD_PTR dwIoBase, BYTE byThreshold);
+void MACvGetRxThreshold(DWORD_PTR dwIoBase, PBYTE pbyThreshold);
 
-VOID MACvSetTxThreshold(DWORD_PTR dwIoBase, BYTE byThreshold);
-VOID MACvGetTxThreshold(DWORD_PTR dwIoBase, PBYTE pbyThreshold);
+void MACvSetTxThreshold(DWORD_PTR dwIoBase, BYTE byThreshold);
+void MACvGetTxThreshold(DWORD_PTR dwIoBase, PBYTE pbyThreshold);
 
-VOID MACvSetDmaLength(DWORD_PTR dwIoBase, BYTE byDmaLength);
-VOID MACvGetDmaLength(DWORD_PTR dwIoBase, PBYTE pbyDmaLength);
+void MACvSetDmaLength(DWORD_PTR dwIoBase, BYTE byDmaLength);
+void MACvGetDmaLength(DWORD_PTR dwIoBase, PBYTE pbyDmaLength);
 
-VOID MACvSetShortRetryLimit(DWORD_PTR dwIoBase, BYTE byRetryLimit);
-VOID MACvGetShortRetryLimit(DWORD_PTR dwIoBase, PBYTE pbyRetryLimit);
+void MACvSetShortRetryLimit(DWORD_PTR dwIoBase, BYTE byRetryLimit);
+void MACvGetShortRetryLimit(DWORD_PTR dwIoBase, PBYTE pbyRetryLimit);
 
-VOID MACvSetLongRetryLimit(DWORD_PTR dwIoBase, BYTE byRetryLimit);
-VOID MACvGetLongRetryLimit(DWORD_PTR dwIoBase, PBYTE pbyRetryLimit);
+void MACvSetLongRetryLimit(DWORD_PTR dwIoBase, BYTE byRetryLimit);
+void MACvGetLongRetryLimit(DWORD_PTR dwIoBase, PBYTE pbyRetryLimit);
 
-VOID MACvSetLoopbackMode(DWORD_PTR dwIoBase, BYTE byLoopbackMode);
+void MACvSetLoopbackMode(DWORD_PTR dwIoBase, BYTE byLoopbackMode);
 BOOL MACbIsInLoopbackMode(DWORD_PTR dwIoBase);
 
-VOID MACvSetPacketFilter(DWORD_PTR dwIoBase, WORD wFilterType);
+void MACvSetPacketFilter(DWORD_PTR dwIoBase, WORD wFilterType);
 
-VOID MACvSaveContext(DWORD_PTR dwIoBase, PBYTE pbyCxtBuf);
-VOID MACvRestoreContext(DWORD_PTR dwIoBase, PBYTE pbyCxtBuf);
+void MACvSaveContext(DWORD_PTR dwIoBase, PBYTE pbyCxtBuf);
+void MACvRestoreContext(DWORD_PTR dwIoBase, PBYTE pbyCxtBuf);
 BOOL MACbCompareContext(DWORD_PTR dwIoBase, PBYTE pbyCxtBuf);
 
 BOOL MACbSoftwareReset(DWORD_PTR dwIoBase);
@@ -1128,14 +1128,14 @@ BOOL MACbSafeRxOff(DWORD_PTR dwIoBase);
 BOOL MACbSafeTxOff(DWORD_PTR dwIoBase);
 BOOL MACbSafeStop(DWORD_PTR dwIoBase);
 BOOL MACbShutdown(DWORD_PTR dwIoBase);
-VOID MACvInitialize(DWORD_PTR dwIoBase);
-VOID MACvSetCurrRx0DescAddr(DWORD_PTR dwIoBase, DWORD dwCurrDescAddr);
-VOID MACvSetCurrRx1DescAddr(DWORD_PTR dwIoBase, DWORD dwCurrDescAddr);
-VOID MACvSetCurrTXDescAddr(int iTxType, DWORD_PTR dwIoBase, DWORD dwCurrDescAddr);
-VOID MACvSetCurrTx0DescAddrEx(DWORD_PTR dwIoBase, DWORD dwCurrDescAddr);
-VOID MACvSetCurrAC0DescAddrEx(DWORD_PTR dwIoBase, DWORD dwCurrDescAddr);
-VOID MACvSetCurrSyncDescAddrEx(DWORD_PTR dwIoBase, DWORD dwCurrDescAddr);
-VOID MACvSetCurrATIMDescAddrEx(DWORD_PTR dwIoBase, DWORD dwCurrDescAddr);
+void MACvInitialize(DWORD_PTR dwIoBase);
+void MACvSetCurrRx0DescAddr(DWORD_PTR dwIoBase, DWORD dwCurrDescAddr);
+void MACvSetCurrRx1DescAddr(DWORD_PTR dwIoBase, DWORD dwCurrDescAddr);
+void MACvSetCurrTXDescAddr(int iTxType, DWORD_PTR dwIoBase, DWORD dwCurrDescAddr);
+void MACvSetCurrTx0DescAddrEx(DWORD_PTR dwIoBase, DWORD dwCurrDescAddr);
+void MACvSetCurrAC0DescAddrEx(DWORD_PTR dwIoBase, DWORD dwCurrDescAddr);
+void MACvSetCurrSyncDescAddrEx(DWORD_PTR dwIoBase, DWORD dwCurrDescAddr);
+void MACvSetCurrATIMDescAddrEx(DWORD_PTR dwIoBase, DWORD dwCurrDescAddr);
 void MACvTimer0MicroSDelay(DWORD_PTR dwIoBase, UINT uDelay);
 void MACvOneShotTimer0MicroSec(DWORD_PTR dwIoBase, UINT uDelayTime);
 void MACvOneShotTimer1MicroSec(DWORD_PTR dwIoBase, UINT uDelayTime);
diff -puN drivers/staging/vt6655/michael.c~vt6655-s-void-void drivers/staging/vt6655/michael.c
--- a/drivers/staging/vt6655/michael.c~vt6655-s-void-void
+++ a/drivers/staging/vt6655/michael.c
@@ -56,12 +56,12 @@
 /*---------------------  Static Functions  --------------------------*/
 /*
 static DWORD s_dwGetUINT32(BYTE * p);         // Get DWORD from 4 bytes LSByte first
-static VOID s_vPutUINT32(BYTE* p, DWORD val); // Put DWORD into 4 bytes LSByte first
+static void s_vPutUINT32(BYTE* p, DWORD val); // Put DWORD into 4 bytes LSByte first
 */
-static VOID s_vClear(void);                       // Clear the internal message,
+static void s_vClear(void);                       // Clear the internal message,
                                               // resets the object to the state just after construction.
-static VOID s_vSetKey(DWORD dwK0, DWORD dwK1);
-static VOID s_vAppendByte(BYTE b);            // Add a single byte to the internal message
+static void s_vSetKey(DWORD dwK0, DWORD dwK1);
+static void s_vAppendByte(BYTE b);            // Add a single byte to the internal message
 
 /*---------------------  Export Variables  --------------------------*/
 static DWORD  L, R;           // Current state
@@ -85,7 +85,7 @@ static DWORD s_dwGetUINT32 (BYTE * p)
     return res;
 }
 
-static VOID s_vPutUINT32 (BYTE* p, DWORD val)
+static void s_vPutUINT32 (BYTE* p, DWORD val)
 // Convert from DWORD to BYTE[] in a portable way
 {
     UINT i;
@@ -97,7 +97,7 @@ static VOID s_vPutUINT32 (BYTE* p, DWORD
 }
 */
 
-static VOID s_vClear (void)
+static void s_vClear (void)
 {
     // Reset the state to the empty message.
     L = K0;
@@ -106,7 +106,7 @@ static VOID s_vClear (void)
     M = 0;
 }
 
-static VOID s_vSetKey (DWORD dwK0, DWORD dwK1)
+static void s_vSetKey (DWORD dwK0, DWORD dwK1)
 {
     // Set the key
     K0 = dwK0;
@@ -115,7 +115,7 @@ static VOID s_vSetKey (DWORD dwK0, DWORD
     s_vClear();
 }
 
-static VOID s_vAppendByte (BYTE b)
+static void s_vAppendByte (BYTE b)
 {
     // Append the byte to our word-sized buffer
     M |= b << (8*nBytesInM);
@@ -138,14 +138,14 @@ static VOID s_vAppendByte (BYTE b)
     }
 }
 
-VOID MIC_vInit (DWORD dwK0, DWORD dwK1)
+void MIC_vInit (DWORD dwK0, DWORD dwK1)
 {
     // Set the key
     s_vSetKey(dwK0, dwK1);
 }
 
 
-VOID MIC_vUnInit (void)
+void MIC_vUnInit (void)
 {
     // Wipe the key material
     K0 = 0;
@@ -156,7 +156,7 @@ VOID MIC_vUnInit (void)
     s_vClear();
 }
 
-VOID MIC_vAppend (PBYTE src, UINT nBytes)
+void MIC_vAppend (PBYTE src, UINT nBytes)
 {
     // This is simple
     while (nBytes > 0)
@@ -166,7 +166,7 @@ VOID MIC_vAppend (PBYTE src, UINT nBytes
     }
 }
 
-VOID MIC_vGetMIC (PDWORD pdwL, PDWORD pdwR)
+void MIC_vGetMIC (PDWORD pdwL, PDWORD pdwR)
 {
     // Append the minimum padding
     s_vAppendByte(0x5a);
diff -puN drivers/staging/vt6655/michael.h~vt6655-s-void-void drivers/staging/vt6655/michael.h
--- a/drivers/staging/vt6655/michael.h~vt6655-s-void-void
+++ a/drivers/staging/vt6655/michael.h
@@ -39,16 +39,16 @@
 
 /*---------------------  Export Types  ------------------------------*/
 
-VOID MIC_vInit(DWORD dwK0, DWORD dwK1);
+void MIC_vInit(DWORD dwK0, DWORD dwK1);
 
-VOID MIC_vUnInit(void);
+void MIC_vUnInit(void);
 
 // Append bytes to the message to be MICed
-VOID MIC_vAppend(PBYTE src, UINT nBytes);
+void MIC_vAppend(PBYTE src, UINT nBytes);
 
 // Get the MIC result. Destination should accept 8 bytes of result.
 // This also resets the message to empty.
-VOID MIC_vGetMIC(PDWORD pdwL, PDWORD pdwR);
+void MIC_vGetMIC(PDWORD pdwL, PDWORD pdwR);
 
 /*---------------------  Export Macros ------------------------------*/
 
diff -puN drivers/staging/vt6655/power.c~vt6655-s-void-void drivers/staging/vt6655/power.c
--- a/drivers/staging/vt6655/power.c~vt6655-s-void-void
+++ a/drivers/staging/vt6655/power.c
@@ -103,7 +103,7 @@ static int          msglevel            
 -*/
 
 
-VOID
+void
 PSvEnablePowerSaving(
     IN HANDLE hDeviceContext,
     IN WORD wListenInterval
@@ -173,7 +173,7 @@ PSvEnablePowerSaving(
  *
 -*/
 
-VOID
+void
 PSvDisablePowerSaving(
     IN HANDLE hDeviceContext
     )
@@ -279,7 +279,7 @@ PSbConsiderPowerDown(
 
 
 
-VOID
+void
 PSvSendPSPOLL(
     IN HANDLE hDeviceContext
     )
diff -puN drivers/staging/vt6655/power.h~vt6655-s-void-void drivers/staging/vt6655/power.h
--- a/drivers/staging/vt6655/power.h~vt6655-s-void-void
+++ a/drivers/staging/vt6655/power.h
@@ -56,18 +56,18 @@ PSbConsiderPowerDown(
     IN BOOL bCheckCountToWakeUp
     );
 
-VOID
+void
 PSvDisablePowerSaving(
     IN HANDLE hDeviceContext
     );
 
-VOID
+void
 PSvEnablePowerSaving(
     IN HANDLE hDeviceContext,
     IN WORD wListenInterval
     );
 
-VOID
+void
 PSvSendPSPOLL(
     IN HANDLE hDeviceContext
     );
diff -puN drivers/staging/vt6655/rc4.c~vt6655-s-void-void drivers/staging/vt6655/rc4.c
--- a/drivers/staging/vt6655/rc4.c~vt6655-s-void-void
+++ a/drivers/staging/vt6655/rc4.c
@@ -31,7 +31,7 @@
 #include "rc4.h"
 #endif
 
-VOID rc4_init(PRC4Ext pRC4, PBYTE pbyKey, UINT cbKey_len)
+void rc4_init(PRC4Ext pRC4, PBYTE pbyKey, UINT cbKey_len)
 {
     UINT  ust1, ust2;
     UINT  keyindex;
@@ -77,7 +77,7 @@ UINT rc4_byte(PRC4Ext pRC4)
     return pbyst[(ustx + usty) & 0xff];
 }
 
-VOID rc4_encrypt(PRC4Ext pRC4, PBYTE pbyDest,
+void rc4_encrypt(PRC4Ext pRC4, PBYTE pbyDest,
                      PBYTE pbySrc, UINT cbData_len)
 {
     UINT ii;
diff -puN drivers/staging/vt6655/rc4.h~vt6655-s-void-void drivers/staging/vt6655/rc4.h
--- a/drivers/staging/vt6655/rc4.h~vt6655-s-void-void
+++ a/drivers/staging/vt6655/rc4.h
@@ -44,7 +44,7 @@ typedef struct {
     BYTE abystate[256];
 } RC4Ext, DEF* PRC4Ext;
 
-VOID rc4_init(PRC4Ext pRC4, PBYTE pbyKey, UINT cbKey_len);
+void rc4_init(PRC4Ext pRC4, PBYTE pbyKey, UINT cbKey_len);
 UINT rc4_byte(PRC4Ext pRC4);
 void rc4_encrypt(PRC4Ext pRC4, PBYTE pbyDest, PBYTE pbySrc, UINT cbData_len);
 
diff -puN drivers/staging/vt6655/rf.c~vt6655-s-void-void drivers/staging/vt6655/rf.c
--- a/drivers/staging/vt6655/rf.c~vt6655-s-void-void
+++ a/drivers/staging/vt6655/rf.c
@@ -1211,7 +1211,7 @@ DWORD   dwMax7230Pwr = 0;
  * Return Value: none
  *
 -*/
-VOID
+void
 RFvRSSITodBm (
     IN  PSDevice pDevice,
     IN  BYTE     byCurrRSSI,
diff -puN drivers/staging/vt6655/rf.h~vt6655-s-void-void drivers/staging/vt6655/rf.h
--- a/drivers/staging/vt6655/rf.h~vt6655-s-void-void
+++ a/drivers/staging/vt6655/rf.h
@@ -96,7 +96,7 @@ BOOL RFbRawSetPower(
     IN  UINT      uRATE
     );
 
-VOID
+void
 RFvRSSITodBm(
     IN  PSDevice pDevice,
     IN  BYTE     byCurrRSSI,
diff -puN drivers/staging/vt6655/rxtx.c~vt6655-s-void-void drivers/staging/vt6655/rxtx.c
--- a/drivers/staging/vt6655/rxtx.c~vt6655-s-void-void
+++ a/drivers/staging/vt6655/rxtx.c
@@ -150,7 +150,7 @@ const WORD wFB_Opt1[2][5] = {
 
 
 static
-VOID
+void
 s_vFillTxKey(
     IN  PSDevice   pDevice,
     IN  PBYTE      pbyBuf,
@@ -164,7 +164,7 @@ s_vFillTxKey(
 
 
 static
-VOID
+void
 s_vFillRTSHead(
     IN PSDevice         pDevice,
     IN BYTE             byPktTyp,
@@ -178,7 +178,7 @@ s_vFillRTSHead(
     );
 
 static
-VOID
+void
 s_vGenerateTxParameter(
     IN PSDevice         pDevice,
     IN  BYTE            byPktTyp,
@@ -245,7 +245,7 @@ s_uFillDataHead (
 
 
 static
-VOID
+void
 s_vFillTxKey (
     IN  PSDevice   pDevice,
     IN  PBYTE      pbyBuf,
@@ -363,7 +363,7 @@ s_vFillTxKey (
 
 
 static
-VOID
+void
 s_vSWencryption (
     IN  PSDevice            pDevice,
     IN  PSKeyItem           pTransmitKey,
@@ -886,7 +886,7 @@ s_uFillDataHead (
 
 
 static
-VOID
+void
 s_vFillRTSHead (
     IN PSDevice         pDevice,
     IN BYTE             byPktTyp,
@@ -1083,7 +1083,7 @@ s_vFillRTSHead (
 }
 
 static
-VOID
+void
 s_vFillCTSHead (
     IN PSDevice pDevice,
     IN UINT     uDMAIdx,
@@ -1188,7 +1188,7 @@ s_vFillCTSHead (
 -*/
 // UINT            cbFrameSize,//Hdr+Payload+FCS
 static
-VOID
+void
 s_vGenerateTxParameter (
     IN PSDevice         pDevice,
     IN BYTE             byPktTyp,
@@ -1306,7 +1306,7 @@ s_vGenerateTxParameter (
     UINT  cbFragmentSize,//Hdr+payoad+FCS
 */
 static
-VOID
+void
 s_vFillFragParameter(
     IN PSDevice pDevice,
     IN PBYTE    pbyBuffer,
@@ -2131,7 +2131,7 @@ s_cbFillTxBufHead (
 }
 
 
-VOID
+void
 vGenerateFIFOHeader (
     IN  PSDevice         pDevice,
     IN  BYTE             byPktTyp,
@@ -2302,7 +2302,7 @@ vGenerateFIFOHeader (
  *
 -*/
 
-VOID
+void
 vGenerateMACHeader (
     IN PSDevice         pDevice,
     IN PBYTE            pbyBufferAddr,
@@ -2863,7 +2863,7 @@ cbGetFragCount (
 }
 
 
-VOID
+void
 vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, PBYTE pbMPDU, UINT cbMPDULen) {
 
     PSTxDesc        pFrstTD;
diff -puN drivers/staging/vt6655/rxtx.h~vt6655-s-void-void drivers/staging/vt6655/rxtx.h
--- a/drivers/staging/vt6655/rxtx.h~vt6655-s-void-void
+++ a/drivers/staging/vt6655/rxtx.h
@@ -55,7 +55,7 @@ extern "C" {                            
 #endif /* __cplusplus */
 
 /*
-VOID vGenerateMACHeader(
+void vGenerateMACHeader(
     IN PSDevice pDevice,
     IN DWORD dwTxBufferAddr,
     IN PBYTE pbySkbData,
@@ -65,7 +65,7 @@ VOID vGenerateMACHeader(
     OUT PUINT pcbAppendPayload
      );
 
-VOID vProcessRxMACHeader (
+void vProcessRxMACHeader (
     IN  PSDevice pDevice,
     IN  DWORD dwRxBufferAddr,
     IN  UINT cbPacketSize,
@@ -75,7 +75,7 @@ VOID vProcessRxMACHeader (
 */
 
 
-VOID
+void
 vGenerateMACHeader (
     IN PSDevice         pDevice,
     IN PBYTE            pbyBufferAddr,
@@ -97,7 +97,7 @@ cbGetFragCount(
     );
 
 
-VOID
+void
 vGenerateFIFOHeader (
     IN  PSDevice         pDevice,
     IN  BYTE             byPktTyp,
@@ -115,7 +115,7 @@ vGenerateFIFOHeader (
     );
 
 
-VOID vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, PBYTE pbMPDU, UINT cbMPDULen);
+void vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, PBYTE pbMPDU, UINT cbMPDULen);
 CMD_STATUS csMgmt_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket);
 CMD_STATUS csBeacon_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket);
 
diff -puN drivers/staging/vt6655/srom.h~vt6655-s-void-void drivers/staging/vt6655/srom.h
--- a/drivers/staging/vt6655/srom.h~vt6655-s-void-void
+++ a/drivers/staging/vt6655/srom.h
@@ -162,7 +162,7 @@ void SROMvWriteAllContents(DWORD_PTR dwI
 void SROMvReadEtherAddress(DWORD_PTR dwIoBase, PBYTE pbyEtherAddress);
 void SROMvWriteEtherAddress(DWORD_PTR dwIoBase, PBYTE pbyEtherAddress);
 
-VOID SROMvReadSubSysVenId(DWORD_PTR dwIoBase, PDWORD pdwSubSysVenId);
+void SROMvReadSubSysVenId(DWORD_PTR dwIoBase, PDWORD pdwSubSysVenId);
 
 BOOL SROMbAutoLoad (DWORD_PTR dwIoBase);
 
diff -puN drivers/staging/vt6655/tkip.c~vt6655-s-void-void drivers/staging/vt6655/tkip.c
--- a/drivers/staging/vt6655/tkip.c~vt6655-s-void-void
+++ a/drivers/staging/vt6655/tkip.c
@@ -195,7 +195,7 @@ unsigned int rotr1(unsigned int a)
  * Return Value: none
  *
  */
-VOID TKIPvMixKey(
+void TKIPvMixKey(
     PBYTE   pbyTKey,
     PBYTE   pbyTA,
     WORD    wTSC15_0,
diff -puN drivers/staging/vt6655/tkip.h~vt6655-s-void-void drivers/staging/vt6655/tkip.h
--- a/drivers/staging/vt6655/tkip.h~vt6655-s-void-void
+++ a/drivers/staging/vt6655/tkip.h
@@ -57,7 +57,7 @@
 extern "C" {                            /* Assume C declarations for C++ */
 #endif /* __cplusplus */
 
-VOID TKIPvMixKey(
+void TKIPvMixKey(
     PBYTE   pbyTKey,
     PBYTE   pbyTA,
     WORD    wTSC15_0,
diff -puN drivers/staging/vt6655/ttype.h~vt6655-s-void-void drivers/staging/vt6655/ttype.h
--- a/drivers/staging/vt6655/ttype.h~vt6655-s-void-void
+++ a/drivers/staging/vt6655/ttype.h
@@ -30,18 +30,6 @@
 
 /******* Common definitions and typedefs ***********************************/
 
-#ifndef VOID
-#define VOID            void
-#endif
-
-#ifndef CONST
-#define CONST           const
-#endif
-
-#ifndef STATIC
-#define STATIC          static
-#endif
-
 #ifndef IN
 #define IN
 #endif
diff -puN drivers/staging/vt6655/vntwifi.c~vt6655-s-void-void drivers/staging/vt6655/vntwifi.c
--- a/drivers/staging/vt6655/vntwifi.c~vt6655-s-void-void
+++ a/drivers/staging/vt6655/vntwifi.c
@@ -88,7 +88,7 @@
  * Return Value: none
  *
 -*/
-VOID
+void
 VNTWIFIvSetOPMode (
     IN PVOID pMgmtHandle,
     IN WMAC_CONFIG_MODE eOPMode
@@ -117,7 +117,7 @@ VNTWIFIvSetOPMode (
  * Return Value: none
  *
 -*/
-VOID
+void
 VNTWIFIvSetIBSSParameter (
     IN PVOID pMgmtHandle,
     IN WORD  wBeaconPeriod,
@@ -325,7 +325,7 @@ VNTWIFIbyGetACKTxRate (
  * Return Value: none
  *
 -*/
-VOID
+void
 VNTWIFIvSetAuthenticationMode (
     IN PVOID pMgmtHandle,
     IN WMAC_AUTHENTICATION_MODE eAuthMode
@@ -357,7 +357,7 @@ VNTWIFIvSetAuthenticationMode (
  * Return Value: none
  *
 -*/
-VOID
+void
 VNTWIFIvSetEncryptionMode (
     IN PVOID pMgmtHandle,
     IN WMAC_ENCRYPTION_MODE eEncryptionMode
@@ -398,7 +398,7 @@ VNTWIFIbConfigPhyMode (
 }
 
 
-VOID
+void
 VNTWIFIbGetConfigPhyMode (
     IN  PVOID pMgmtHandle,
     OUT PVOID pePhyType
@@ -443,7 +443,7 @@ VNTWIFIbGetConfigPhyMode (
  *
 -*/
 
-VOID
+void
 VNTWIFIvQueryBSSList (
     IN PVOID    pMgmtHandle,
     OUT PUINT   puBSSCount,
@@ -473,7 +473,7 @@ VNTWIFIvQueryBSSList (
 
 
 
-VOID
+void
 VNTWIFIvGetNextBSS (
     IN PVOID            pMgmtHandle,
     IN PVOID            pvCurrentBSS,
@@ -513,7 +513,7 @@ VNTWIFIvGetNextBSS (
  * Return Value: none
  *
 -*/
-VOID
+void
 VNTWIFIvUpdateNodeTxCounter(
     IN PVOID    pMgmtHandle,
     IN PBYTE    pbyDestAddress,
@@ -548,7 +548,7 @@ VNTWIFIvUpdateNodeTxCounter(
 }
 
 
-VOID
+void
 VNTWIFIvGetTxRate(
     IN PVOID    pMgmtHandle,
     IN PBYTE    pbyDestAddress,
@@ -721,7 +721,7 @@ VNTWIFIwGetMaxSupportRate(
 }
 
 
-VOID
+void
 VNTWIFIvSet11h (
     IN PVOID pMgmtObject,
     IN BOOL  b11hEnable
diff -puN drivers/staging/vt6655/vntwifi.h~vt6655-s-void-void drivers/staging/vt6655/vntwifi.h
--- a/drivers/staging/vt6655/vntwifi.h~vt6655-s-void-void
+++ a/drivers/staging/vt6655/vntwifi.h
@@ -152,7 +152,7 @@ extern "C" {                            
 #endif /* __cplusplus */
 
 
-VOID
+void
 VNTWIFIvSetIBSSParameter (
     IN PVOID pMgmtHandle,
     IN WORD  wBeaconPeriod,
@@ -160,7 +160,7 @@ VNTWIFIvSetIBSSParameter (
     IN UINT  uChannel
     );
 
-VOID
+void
 VNTWIFIvSetOPMode (
     IN PVOID pMgmtHandle,
     IN WMAC_CONFIG_MODE eOPMode
@@ -194,13 +194,13 @@ VNTWIFIbyGetACKTxRate (
     IN PWLAN_IE_SUPP_RATES pExtSupportRateIEs
     );
 
-VOID
+void
 VNTWIFIvSetAuthenticationMode (
     IN PVOID pMgmtHandle,
     IN WMAC_AUTHENTICATION_MODE eAuthMode
     );
 
-VOID
+void
 VNTWIFIvSetEncryptionMode (
     IN PVOID pMgmtHandle,
     IN WMAC_ENCRYPTION_MODE eEncryptionMode
@@ -213,13 +213,13 @@ VNTWIFIbConfigPhyMode(
     IN CARD_PHY_TYPE ePhyType
     );
 
-VOID
+void
 VNTWIFIbGetConfigPhyMode(
     IN  PVOID pMgmtHandle,
     OUT PVOID pePhyType
     );
 
-VOID
+void
 VNTWIFIvQueryBSSList(
     IN PVOID    pMgmtHandle,
     OUT PUINT   puBSSCount,
@@ -229,7 +229,7 @@ VNTWIFIvQueryBSSList(
 
 
 
-VOID
+void
 VNTWIFIvGetNextBSS (
     IN PVOID            pMgmtHandle,
     IN PVOID            pvCurrentBSS,
@@ -238,7 +238,7 @@ VNTWIFIvGetNextBSS (
 
 
 
-VOID
+void
 VNTWIFIvUpdateNodeTxCounter(
     IN PVOID    pMgmtHandle,
     IN PBYTE    pbyDestAddress,
@@ -248,7 +248,7 @@ VNTWIFIvUpdateNodeTxCounter(
     );
 
 
-VOID
+void
 VNTWIFIvGetTxRate(
     IN PVOID    pMgmtHandle,
     IN PBYTE    pbyDestAddress,
@@ -292,7 +292,7 @@ VNTWIFIwGetMaxSupportRate(
     );
 
 // for 802.11h
-VOID
+void
 VNTWIFIvSet11h (
     IN PVOID pMgmtObject,
     IN BOOL  b11hEnable
diff -puN drivers/staging/vt6655/wcmd.c~vt6655-s-void-void drivers/staging/vt6655/wcmd.c
--- a/drivers/staging/vt6655/wcmd.c~vt6655-s-void-void
+++ a/drivers/staging/vt6655/wcmd.c
@@ -105,7 +105,7 @@ static int          msglevel            
 /*---------------------  Static Functions  --------------------------*/
 
 static
-VOID
+void
 s_vProbeChannel(
     IN PSDevice pDevice
     );
@@ -236,7 +236,7 @@ vAdHocBeaconRestart(PSDevice pDevice)
 -*/
 
 static
-VOID
+void
 s_vProbeChannel(
     IN PSDevice pDevice
     )
@@ -350,7 +350,7 @@ s_MgrMakeProbeRequest(
 
 
 
-VOID
+void
 vCommandTimerWait(
     IN HANDLE    hDeviceContext,
     IN UINT MSecond
@@ -369,7 +369,7 @@ vCommandTimerWait(
 
 
 
-VOID
+void
 vCommandTimer (
     IN  HANDLE      hDeviceContext
     )
@@ -1113,7 +1113,7 @@ BOOL bClearBSSID_SCAN (
 }
 
 //mike add:reset command timer
-VOID
+void
 vResetCommandTimer(
     IN HANDLE      hDeviceContext
     )
@@ -1137,7 +1137,7 @@ vResetCommandTimer(
 
 
 #ifdef TxInSleep
-VOID
+void
 BSSvSecondTxData(
     IN  HANDLE      hDeviceContext
     )
diff -puN drivers/staging/vt6655/wcmd.h~vt6655-s-void-void drivers/staging/vt6655/wcmd.h
--- a/drivers/staging/vt6655/wcmd.h~vt6655-s-void-void
+++ a/drivers/staging/vt6655/wcmd.h
@@ -116,12 +116,12 @@ typedef enum tagCMD_STATE {
 
 /*---------------------  Export Functions  --------------------------*/
 
-VOID
+void
 vResetCommandTimer(
     IN HANDLE      hDeviceContext
     );
 
-VOID
+void
 vCommandTimer (
     IN  HANDLE hDeviceContext
     );
@@ -137,13 +137,13 @@ bScheduleCommand(
     IN PBYTE       pbyItem0
     );
 
-VOID
+void
 vCommandTimerWait(
     IN HANDLE      hDeviceContext,
     IN UINT MSecond
     );
 #ifdef TxInSleep
-VOID
+void
 BSSvSecondTxData(
     IN  HANDLE      hDeviceContext
     );
diff -puN drivers/staging/vt6655/wmgr.c~vt6655-s-void-void drivers/staging/vt6655/wmgr.c
--- a/drivers/staging/vt6655/wmgr.c~vt6655-s-void-void
+++ a/drivers/staging/vt6655/wmgr.c
@@ -152,7 +152,7 @@ s_MgrMakeAssocRequest(
     );
 
 static
-VOID
+void
 s_vMgrRxAssocRequest(
     IN PSDevice pDevice,
     IN PSMgmtObject pMgmt,
@@ -174,7 +174,7 @@ s_MgrMakeReAssocRequest(
     );
 
 static
-VOID
+void
 s_vMgrRxAssocResponse(
     IN PSDevice pDevice,
     IN PSMgmtObject pMgmt,
@@ -183,7 +183,7 @@ s_vMgrRxAssocResponse(
     );
 
 static
-VOID
+void
 s_vMgrRxDisassociation(
     IN PSDevice pDevice,
     IN PSMgmtObject pMgmt,
@@ -192,7 +192,7 @@ s_vMgrRxDisassociation(
 
 // Authentication/deauthen functions
 static
-VOID
+void
 s_vMgrRxAuthenSequence_1(
     IN PSDevice pDevice,
     IN PSMgmtObject pMgmt,
@@ -200,7 +200,7 @@ s_vMgrRxAuthenSequence_1(
     );
 
 static
-VOID
+void
 s_vMgrRxAuthenSequence_2(
     IN PSDevice pDevice,
     IN PSMgmtObject pMgmt,
@@ -208,7 +208,7 @@ s_vMgrRxAuthenSequence_2(
     );
 
 static
-VOID
+void
 s_vMgrRxAuthenSequence_3(
     IN PSDevice pDevice,
     IN PSMgmtObject pMgmt,
@@ -216,7 +216,7 @@ s_vMgrRxAuthenSequence_3(
     );
 
 static
-VOID
+void
 s_vMgrRxAuthenSequence_4(
     IN PSDevice pDevice,
     IN PSMgmtObject pMgmt,
@@ -224,7 +224,7 @@ s_vMgrRxAuthenSequence_4(
     );
 
 static
-VOID
+void
 s_vMgrRxAuthentication(
     IN PSDevice pDevice,
     IN PSMgmtObject pMgmt,
@@ -232,7 +232,7 @@ s_vMgrRxAuthentication(
     );
 
 static
-VOID
+void
 s_vMgrRxDeauthentication(
     IN PSDevice pDevice,
     IN PSMgmtObject pMgmt,
@@ -242,7 +242,7 @@ s_vMgrRxDeauthentication(
 // Scan functions
 // probe request/response functions
 static
-VOID
+void
 s_vMgrRxProbeRequest(
     IN PSDevice pDevice,
     IN PSMgmtObject pMgmt,
@@ -250,7 +250,7 @@ s_vMgrRxProbeRequest(
     );
 
 static
-VOID
+void
 s_vMgrRxProbeResponse(
     IN PSDevice pDevice,
     IN PSMgmtObject pMgmt,
@@ -259,7 +259,7 @@ s_vMgrRxProbeResponse(
 
 // beacon functions
 static
-VOID
+void
 s_vMgrRxBeacon(
     IN PSDevice pDevice,
     IN PSMgmtObject pMgmt,
@@ -268,7 +268,7 @@ s_vMgrRxBeacon(
     );
 
 static
-VOID
+void
 s_vMgrFormatTIM(
     IN PSMgmtObject pMgmt,
     IN PWLAN_IE_TIM pTIM
@@ -338,7 +338,7 @@ s_MgrMakeProbeResponse(
 
 // received status
 static
-VOID
+void
 s_vMgrLogStatus(
     IN PSMgmtObject pMgmt,
     IN WORD wStatus
@@ -346,7 +346,7 @@ s_vMgrLogStatus(
 
 
 static
-VOID
+void
 s_vMgrSynchBSS (
     IN PSDevice      pDevice,
     IN UINT          uBSSMode,
@@ -364,19 +364,19 @@ s_bCipherMatch (
     );
 
 
- static VOID  Encyption_Rebuild(
+ static void  Encyption_Rebuild(
     IN PSDevice pDevice,
     IN PKnownBSS pCurr
  );
 /*
 static
-VOID
+void
 s_vProbeChannel(
     IN PSDevice pDevice
     );
 
 static
-VOID
+void
 s_vListenChannel(
     IN PSDevice pDevice
     );
@@ -409,7 +409,7 @@ s_MgrMakeProbeRequest(
  *
 -*/
 
-VOID
+void
 vMgrObjectInit(
     IN  HANDLE hDeviceContext
     )
@@ -493,7 +493,7 @@ vMgrTimerInit(
  *
 -*/
 
-VOID
+void
 vMgrObjectReset(
     IN  HANDLE hDeviceContext
     )
@@ -522,7 +522,7 @@ vMgrObjectReset(
 -*/
 
 
-VOID
+void
 vMgrAssocBeginSta(
     IN  HANDLE hDeviceContext,
     IN  PSMgmtObject pMgmt,
@@ -598,7 +598,7 @@ vMgrAssocBeginSta(
  *
 -*/
 
-VOID
+void
 vMgrReAssocBeginSta(
     IN  HANDLE hDeviceContext,
     IN  PSMgmtObject pMgmt,
@@ -677,7 +677,7 @@ vMgrReAssocBeginSta(
  *
 -*/
 
-VOID
+void
 vMgrDisassocBeginSta(
     IN  HANDLE hDeviceContext,
     IN  PSMgmtObject pMgmt,
@@ -740,7 +740,7 @@ vMgrDisassocBeginSta(
 -*/
 
 static
-VOID
+void
 s_vMgrRxAssocRequest(
     IN PSDevice pDevice,
     IN PSMgmtObject pMgmt,
@@ -902,7 +902,7 @@ s_vMgrRxAssocRequest(
 -*/
 
 static
-VOID
+void
 s_vMgrRxReAssocRequest(
     IN PSDevice pDevice,
     IN PSMgmtObject pMgmt,
@@ -1052,7 +1052,7 @@ s_vMgrRxReAssocRequest(
 -*/
 
 static
-VOID
+void
 s_vMgrRxAssocResponse(
     IN PSDevice pDevice,
     IN PSMgmtObject pMgmt,
@@ -1212,7 +1212,7 @@ if(pMgmt->eCurrState == WMAC_STATE_ASSOC
  *
 -*/
 
-VOID
+void
 vMgrAuthenBeginSta(
     IN  HANDLE hDeviceContext,
     IN  PSMgmtObject  pMgmt,
@@ -1270,7 +1270,7 @@ vMgrAuthenBeginSta(
  *
 -*/
 
-VOID
+void
 vMgrDeAuthenBeginSta(
     IN  HANDLE hDeviceContext,
     IN  PSMgmtObject  pMgmt,
@@ -1327,7 +1327,7 @@ vMgrDeAuthenBeginSta(
 -*/
 
 static
-VOID
+void
 s_vMgrRxAuthentication(
     IN PSDevice pDevice,
     IN PSMgmtObject pMgmt,
@@ -1385,7 +1385,7 @@ s_vMgrRxAuthentication(
 
 
 static
-VOID
+void
 s_vMgrRxAuthenSequence_1(
     IN PSDevice pDevice,
     IN PSMgmtObject pMgmt,
@@ -1491,7 +1491,7 @@ s_vMgrRxAuthenSequence_1(
 -*/
 
 static
-VOID
+void
 s_vMgrRxAuthenSequence_2(
     IN PSDevice pDevice,
     IN PSMgmtObject pMgmt,
@@ -1593,7 +1593,7 @@ s_vMgrRxAuthenSequence_2(
 -*/
 
 static
-VOID
+void
 s_vMgrRxAuthenSequence_3(
     IN PSDevice pDevice,
     IN PSMgmtObject pMgmt,
@@ -1681,7 +1681,7 @@ reply:
  *
 -*/
 static
-VOID
+void
 s_vMgrRxAuthenSequence_4(
     IN PSDevice pDevice,
     IN PSMgmtObject pMgmt,
@@ -1720,7 +1720,7 @@ s_vMgrRxAuthenSequence_4(
 -*/
 
 static
-VOID
+void
 s_vMgrRxDisassociation(
     IN PSDevice pDevice,
     IN PSMgmtObject pMgmt,
@@ -1800,7 +1800,7 @@ s_vMgrRxDisassociation(
 -*/
 
 static
-VOID
+void
 s_vMgrRxDeauthentication(
     IN PSDevice pDevice,
     IN PSMgmtObject pMgmt,
@@ -1926,7 +1926,7 @@ ChannelExceedZoneType(
 -*/
 
 static
-VOID
+void
 s_vMgrRxBeacon(
     IN PSDevice pDevice,
     IN PSMgmtObject pMgmt,
@@ -2447,7 +2447,7 @@ if(ChannelExceedZoneType(pDevice,byCurrC
  *    CMD_STATUS
  *
 -*/
-VOID
+void
 vMgrCreateOwnIBSS(
     IN  HANDLE hDeviceContext,
     OUT PCMD_STATUS pStatus
@@ -2714,7 +2714,7 @@ vMgrCreateOwnIBSS(
  *
 -*/
 
-VOID
+void
 vMgrJoinBSSBegin(
     IN  HANDLE hDeviceContext,
     OUT PCMD_STATUS pStatus
@@ -2983,7 +2983,7 @@ vMgrJoinBSSBegin(
  *
 -*/
 static
-VOID
+void
 s_vMgrSynchBSS (
     IN PSDevice      pDevice,
     IN UINT          uBSSMode,
@@ -3151,7 +3151,7 @@ s_vMgrSynchBSS (
 
 //mike add: fix NetworkManager 0.7.0 hidden ssid mode in WPA encryption
 //                   ,need reset eAuthenMode and eEncryptionStatus
- static VOID  Encyption_Rebuild(
+ static void  Encyption_Rebuild(
     IN PSDevice pDevice,
     IN PKnownBSS pCurr
  )
@@ -3203,12 +3203,12 @@ s_vMgrSynchBSS (
  *
  *
  * Return Value:
- *    VOID
+ *    void
  *
 -*/
 
 static
-VOID
+void
 s_vMgrFormatTIM(
     IN PSMgmtObject pMgmt,
     IN PWLAN_IE_TIM pTIM
@@ -4369,7 +4369,7 @@ s_MgrMakeReAssocResponse(
 -*/
 
 static
-VOID
+void
 s_vMgrRxProbeResponse(
     IN PSDevice pDevice,
     IN PSMgmtObject pMgmt,
@@ -4494,7 +4494,7 @@ if(ChannelExceedZoneType(pDevice,byCurrC
 
 
 static
-VOID
+void
 s_vMgrRxProbeRequest(
     IN PSDevice pDevice,
     IN PSMgmtObject pMgmt,
@@ -4590,7 +4590,7 @@ s_vMgrRxProbeRequest(
 -*/
 
 
-VOID
+void
 vMgrRxManagePacket(
     IN  HANDLE hDeviceContext,
     IN PSMgmtObject pMgmt,
@@ -4794,7 +4794,7 @@ bMgrPrepareBeaconToSend(
  *
 -*/
 static
-VOID
+void
 s_vMgrLogStatus(
     IN PSMgmtObject pMgmt,
     IN WORD  wStatus
@@ -4924,7 +4924,7 @@ bAdd_PMKID_Candidate (
  * Return Value: none.
  *
 -*/
-VOID
+void
 vFlush_PMKID_Candidate (
     IN HANDLE hDeviceContext
     )
diff -puN drivers/staging/vt6655/wmgr.h~vt6655-s-void-void drivers/staging/vt6655/wmgr.h
--- a/drivers/staging/vt6655/wmgr.h~vt6655-s-void-void
+++ a/drivers/staging/vt6655/wmgr.h
@@ -428,7 +428,7 @@ vMgrTimerInit(
     IN  HANDLE hDeviceContext
     );
 
-VOID
+void
 vMgrObjectReset(
     IN  HANDLE hDeviceContext
     );
@@ -440,14 +440,14 @@ vMgrAssocBeginSta(
     OUT PCMD_STATUS pStatus
     );
 
-VOID
+void
 vMgrReAssocBeginSta(
     IN  HANDLE hDeviceContext,
     IN  PSMgmtObject pMgmt,
     OUT PCMD_STATUS pStatus
     );
 
-VOID
+void
 vMgrDisassocBeginSta(
     IN  HANDLE hDeviceContext,
     IN  PSMgmtObject pMgmt,
@@ -456,26 +456,26 @@ vMgrDisassocBeginSta(
     OUT PCMD_STATUS pStatus
     );
 
-VOID
+void
 vMgrAuthenBeginSta(
     IN  HANDLE hDeviceContext,
     IN  PSMgmtObject pMgmt,
     OUT PCMD_STATUS pStatus
     );
 
-VOID
+void
 vMgrCreateOwnIBSS(
     IN  HANDLE hDeviceContext,
     OUT PCMD_STATUS pStatus
     );
 
-VOID
+void
 vMgrJoinBSSBegin(
     IN  HANDLE hDeviceContext,
     OUT PCMD_STATUS pStatus
     );
 
-VOID
+void
 vMgrRxManagePacket(
     IN  HANDLE hDeviceContext,
     IN  PSMgmtObject pMgmt,
@@ -483,14 +483,14 @@ vMgrRxManagePacket(
     );
 
 /*
-VOID
+void
 vMgrScanBegin(
     IN  HANDLE hDeviceContext,
     OUT PCMD_STATUS pStatus
     );
 */
 
-VOID
+void
 vMgrDeAuthenBeginSta(
     IN  HANDLE hDeviceContext,
     IN  PSMgmtObject  pMgmt,
@@ -513,7 +513,7 @@ bAdd_PMKID_Candidate (
     IN PSRSNCapObject psRSNCapObj
     );
 
-VOID
+void
 vFlush_PMKID_Candidate (
     IN HANDLE hDeviceContext
     );
diff -puN drivers/staging/vt6655/wpa.c~vt6655-s-void-void drivers/staging/vt6655/wpa.c
--- a/drivers/staging/vt6655/wpa.c~vt6655-s-void-void
+++ a/drivers/staging/vt6655/wpa.c
@@ -91,7 +91,7 @@ const BYTE abyOUI05[4] = { 0x00, 0x50, 0
  *
 -*/
 
-VOID
+void
 WPA_ClearRSN (
     IN PKnownBSS        pBSSList
     )
@@ -127,7 +127,7 @@ WPA_ClearRSN (
  * Return Value: none.
  *
 -*/
-VOID
+void
 WPA_ParseRSN (
     IN PKnownBSS        pBSSList,
     IN PWLAN_IE_RSN_EXT pRSN
diff -puN drivers/staging/vt6655/wpa.h~vt6655-s-void-void drivers/staging/vt6655/wpa.h
--- a/drivers/staging/vt6655/wpa.h~vt6655-s-void-void
+++ a/drivers/staging/vt6655/wpa.h
@@ -67,12 +67,12 @@
 extern "C" {                            /* Assume C declarations for C++ */
 #endif /* __cplusplus */
 
-VOID
+void
 WPA_ClearRSN(
     IN PKnownBSS        pBSSList
     );
 
-VOID
+void
 WPA_ParseRSN(
     IN PKnownBSS        pBSSList,
     IN PWLAN_IE_RSN_EXT pRSN
diff -puN drivers/staging/vt6655/wpa2.c~vt6655-s-void-void drivers/staging/vt6655/wpa2.c
--- a/drivers/staging/vt6655/wpa2.c~vt6655-s-void-void
+++ a/drivers/staging/vt6655/wpa2.c
@@ -81,7 +81,7 @@ const BYTE abyOUIPSK[4]     = { 0x00, 0x
  * Return Value: none.
  *
 -*/
-VOID
+void
 WPA2_ClearRSN (
     IN PKnownBSS        pBSSNode
     )
@@ -116,7 +116,7 @@ WPA2_ClearRSN (
  * Return Value: none.
  *
 -*/
-VOID
+void
 WPA2vParseRSN (
     IN PKnownBSS        pBSSNode,
     IN PWLAN_IE_RSN     pRSN
diff -puN drivers/staging/vt6655/wpa2.h~vt6655-s-void-void drivers/staging/vt6655/wpa2.h
--- a/drivers/staging/vt6655/wpa2.h~vt6655-s-void-void
+++ a/drivers/staging/vt6655/wpa2.h
@@ -74,12 +74,12 @@ typedef struct tagSPMKIDCache {
 extern "C" {                            /* Assume C declarations for C++ */
 #endif /* __cplusplus */
 
-VOID
+void
 WPA2_ClearRSN (
     IN PKnownBSS        pBSSNode
     );
 
-VOID
+void
 WPA2vParseRSN (
     IN PKnownBSS        pBSSNode,
     IN PWLAN_IE_RSN     pRSN
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

linux-next.patch
comedi-jr3_pcic-add-required-includes.patch
vt6655-fix-build-when-config_wireless_ext.patch
vt6655-remove-dependency-on-wireless_ext-version.patch
stlc45xx-convert-config_interface-to-bss_info_changed.patch
vt6655-s-void-void.patch

