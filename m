From: akpm@linux-foundation.org
Subject: - cxacru-add-documentation-file.patch removed from -mm tree
Date: Mon, 21 May 2007 16:17:08 -0700
Message-ID: <200705212317.l4LNH7sG022445@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55091 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756932AbXEUXUP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 19:20:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: simon@fire.lp0.eu, duncan.sands@math.u-psud.fr, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     cxacru: add Documentation file
has been removed from the -mm tree.  Its filename was
     cxacru-add-documentation-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cxacru: add Documentation file
From: Simon Arlott <simon@fire.lp0.eu>

The sysfs attributes for exposing cxacru statistics/status information with
possible values is now explained in Documentation/networking/cxacru.txt
including information on the writable adsl_state attribute's commands and a
sample of the kernel log format.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Duncan Sands <duncan.sands@math.u-psud.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/networking/00-INDEX   |    2 
 Documentation/networking/cxacru.txt |   84 ++++++++++++++++++++++++++
 2 files changed, 86 insertions(+)

diff -puN Documentation/networking/00-INDEX~cxacru-add-documentation-file Documentation/networking/00-INDEX
--- a/Documentation/networking/00-INDEX~cxacru-add-documentation-file
+++ a/Documentation/networking/00-INDEX
@@ -32,6 +32,8 @@ cops.txt
 	- info on the COPS LocalTalk Linux driver
 cs89x0.txt
 	- the Crystal LAN (CS8900/20-based) Ethernet ISA adapter driver
+cxacru.txt
+	- Conexant AccessRunner USB ADSL Modem
 de4x5.txt
 	- the Digital EtherWORKS DE4?? and DE5?? PCI Ethernet driver
 decnet.txt
diff -puN /dev/null Documentation/networking/cxacru.txt
--- /dev/null
+++ a/Documentation/networking/cxacru.txt
@@ -0,0 +1,84 @@
+Firmware is required for this device: http://accessrunner.sourceforge.net/
+
+While it is capable of managing/maintaining the ADSL connection without the
+module loaded, the device will sometimes stop responding after unloading the
+driver and it is necessary to unplug/remove power to the device to fix this.
+
+Detected devices will appear as ATM devices named "cxacru". In /sys/class/atm/
+these are directories named cxacruN where N is the device number. A symlink
+named device points to the USB interface device's directory which contains
+several sysfs attribute files for retrieving device statistics:
+
+* adsl_controller_version
+
+* adsl_headend
+* adsl_headend_environment
+	Information about the remote headend.
+
+* downstream_attenuation (dB)
+* downstream_bits_per_frame
+* downstream_rate (kbps)
+* downstream_snr_margin (dB)
+	Downstream stats.
+
+* upstream_attenuation (dB)
+* upstream_bits_per_frame
+* upstream_rate (kbps)
+* upstream_snr_margin (dB)
+* transmitter_power (dBm/Hz)
+	Upstream stats.
+
+* downstream_crc_errors
+* downstream_fec_errors
+* downstream_hec_errors
+* upstream_crc_errors
+* upstream_fec_errors
+* upstream_hec_errors
+	Error counts.
+
+* line_startable
+	Indicates that ADSL support on the device
+	is/can be enabled, see adsl_start.
+
+* line_status
+	"initialising"
+	"down"
+	"attempting to activate"
+	"training"
+	"channel analysis"
+	"exchange"
+	"waiting"
+	"up"
+
+	Changes between "down" and "attempting to activate"
+	if there is no signal.
+
+* link_status
+	"not connected"
+	"connected"
+	"lost"
+
+* mac_address
+
+* modulation
+	"ANSI T1.413"
+	"ITU-T G.992.1 (G.DMT)"
+	"ITU-T G.992.2 (G.LITE)"
+
+* startup_attempts
+	Count of total attempts to initialise ADSL.
+
+To enable/disable ADSL, the following can be written to the adsl_state file:
+	"start"
+	"stop
+	"restart" (stops, waits 1.5s, then starts)
+	"poll" (used to resume status polling if it was disabled due to failure)
+
+Changes in adsl/line state are reported via kernel log messages:
+	[4942145.150704] ATM dev 0: ADSL state: running
+	[4942243.663766] ATM dev 0: ADSL line: down
+	[4942249.665075] ATM dev 0: ADSL line: attempting to activate
+	[4942253.654954] ATM dev 0: ADSL line: training
+	[4942255.666387] ATM dev 0: ADSL line: channel analysis
+	[4942259.656262] ATM dev 0: ADSL line: exchange
+	[2635357.696901] ATM dev 0: ADSL line: up (8128 kb/s down | 832 kb/s up)
_

Patches currently in -mm which might be from simon@fire.lp0.eu are

origin.patch
git-dvb.patch
git-sh.patch
git-xtensa.patch
