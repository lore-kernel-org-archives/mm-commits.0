From: akpm@linux-foundation.org
Subject: + removes-array_size-duplicates.patch added to -mm tree
Date: Fri, 28 Sep 2007 14:57:35 -0700
Message-ID: <200709282157.l8SLva8g019416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42626 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751567AbXI1V67 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Sep 2007 17:58:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, adaplas@pol.net, ak@suse.de, davem@davemloft.net, geert@linux-m68k.org, hpa@zytor.com, jeff@garzik.org, kaber@trash.net, lenb@kernel.org, linville@tuxdriver.com, zippel@linux-m68k.org


The patch titled
     remove array_size duplicates
has been added to the -mm tree.  Its filename is
     removes-array_size-duplicates.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove array_size duplicates
From: Roel Kluin <12o3l@tiscali.nl>

Remove some ARRAY_SIZE macro duplicates.  There is also one in
arch/um/include/user.h, which isn't fixed here because comments in that
file explicitly state a preference for the 'less fancy' version.  If that's
the case as well for any of the other replacements please comment.

Several #defines in net drivers were found to be unused and are simply deleted.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Len Brown <lenb@kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/spi/spidev_test.c~removes-array_size-duplicates Documentation/spi/spidev_test.c
--- a/Documentation/spi/spidev_test.c~removes-array_size-duplicates
+++ a/Documentation/spi/spidev_test.c
@@ -21,8 +21,6 @@
 #include <linux/types.h>
 #include <linux/spi/spidev.h>
 
-#define ARRAY_SIZE(a) (sizeof(a) / sizeof((a)[0]))
-
 static void pabort(const char *s)
 {
 	perror(s);
diff -puN arch/i386/boot/compressed/relocs.c~removes-array_size-duplicates arch/i386/boot/compressed/relocs.c
--- a/arch/i386/boot/compressed/relocs.c~removes-array_size-duplicates
+++ a/arch/i386/boot/compressed/relocs.c
@@ -11,7 +11,6 @@
 #include <endian.h>
 
 #define MAX_SHDRS 100
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 static Elf32_Ehdr ehdr;
 static Elf32_Shdr shdr[MAX_SHDRS];
 static Elf32_Sym  *symtab[MAX_SHDRS];
diff -puN arch/m68k/amiga/amisound.c~removes-array_size-duplicates arch/m68k/amiga/amisound.c
--- a/arch/m68k/amiga/amisound.c~removes-array_size-duplicates
+++ a/arch/m68k/amiga/amisound.c
@@ -21,7 +21,6 @@ static const signed char sine_data[] = {
 	0,  39,  75,  103,  121,  127,  121,  103,  75,  39,
 	0, -39, -75, -103, -121, -127, -121, -103, -75, -39
 };
-#define DATA_SIZE	(sizeof(sine_data)/sizeof(sine_data[0]))
 
 #define custom amiga_custom
 
@@ -55,7 +54,7 @@ void __init amiga_init_sound(void)
 	memcpy (snd_data, sine_data, sizeof(sine_data));
 
 	/* setup divisor */
-	clock_constant = (amiga_colorclock+DATA_SIZE/2)/DATA_SIZE;
+	clock_constant = (amiga_colorclock + ARRAY_SIZE(sine_data) /2) / ARRAY_SIZE(sine_data);
 
 	/* without amifb, turn video off and enable high quality sound */
 #ifndef CONFIG_FB_AMIGA
diff -puN arch/powerpc/boot/types.h~removes-array_size-duplicates arch/powerpc/boot/types.h
--- a/arch/powerpc/boot/types.h~removes-array_size-duplicates
+++ a/arch/powerpc/boot/types.h
@@ -1,8 +1,6 @@
 #ifndef _TYPES_H_
 #define _TYPES_H_
 
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
-
 typedef unsigned char		u8;
 typedef unsigned short		u16;
 typedef unsigned int		u32;
diff -puN arch/sparc64/kernel/pci.c~removes-array_size-duplicates arch/sparc64/kernel/pci.c
--- a/arch/sparc64/kernel/pci.c~removes-array_size-duplicates
+++ a/arch/sparc64/kernel/pci.c
@@ -209,14 +209,12 @@ static struct {
 	{ "SUNW,sun4v-pci", sun4v_pci_init },
 	{ "pciex108e,80f0", fire_pci_init },
 };
-#define PCI_NUM_CONTROLLER_TYPES (sizeof(pci_controller_table) / \
-				  sizeof(pci_controller_table[0]))
 
 static int __init pci_controller_init(const char *model_name, int namelen, struct device_node *dp)
 {
 	int i;
 
-	for (i = 0; i < PCI_NUM_CONTROLLER_TYPES; i++) {
+	for (i = 0; i < ARRAY_SIZE(pci_controller_table); i++) {
 		if (!strncmp(model_name,
 			     pci_controller_table[i].model_name,
 			     namelen)) {
@@ -232,7 +230,7 @@ static int __init pci_is_controller(cons
 {
 	int i;
 
-	for (i = 0; i < PCI_NUM_CONTROLLER_TYPES; i++) {
+	for (i = 0; i < ARRAY_SIZE(pci_controller_table); i++) {
 		if (!strncmp(model_name,
 			     pci_controller_table[i].model_name,
 			     namelen)) {
diff -puN drivers/acpi/utilities/uteval.c~removes-array_size-duplicates drivers/acpi/utilities/uteval.c
--- a/drivers/acpi/utilities/uteval.c~removes-array_size-duplicates
+++ a/drivers/acpi/utilities/uteval.c
@@ -122,7 +122,7 @@ acpi_status acpi_ut_osi_implementation(s
 
 	/* Compare input string to static table of supported interfaces */
 
-	for (i = 0; i < ACPI_ARRAY_LENGTH(acpi_interfaces_supported); i++) {
+	for (i = 0; i < ARRAY_SIZE(acpi_interfaces_supported); i++) {
 		if (!ACPI_STRCMP
 		    (string_desc->string.pointer,
 		     acpi_interfaces_supported[i])) {
@@ -168,7 +168,7 @@ acpi_status acpi_osi_invalidate(char *in
 {
 	int i;
 
-	for (i = 0; i < ACPI_ARRAY_LENGTH(acpi_interfaces_supported); i++) {
+	for (i = 0; i < ARRAY_SIZE(acpi_interfaces_supported); i++) {
 		if (!ACPI_STRCMP(interface, acpi_interfaces_supported[i])) {
 			*acpi_interfaces_supported[i] = '\0';
 			return AE_OK;
diff -puN drivers/net/irda/actisys-sir.c~removes-array_size-duplicates drivers/net/irda/actisys-sir.c
--- a/drivers/net/irda/actisys-sir.c~removes-array_size-duplicates
+++ a/drivers/net/irda/actisys-sir.c
@@ -67,8 +67,6 @@ static int actisys_reset(struct sir_dev 
 /* Note : the 220L doesn't support 38400, but we will fix that below */
 static unsigned baud_rates[] = { 9600, 19200, 57600, 115200, 38400 };
 
-#define MAX_SPEEDS ARRAY_SIZE(baud_rates)
-
 static struct dongle_driver act220l = {
 	.owner		= THIS_MODULE,
 	.driver_name	= "Actisys ACT-220L",
@@ -176,7 +174,7 @@ static int actisys_change_speed(struct s
 	 * Now, we can set the speed requested. Send RTS pulses until we
          * reach the target speed 
 	 */
-	for (i = 0; i < MAX_SPEEDS; i++) {
+	for (i = 0; i < ARRAY_SIZE(baud_rates); i++) {
 		if (speed == baud_rates[i]) {
 			dev->speed = speed;
 			break;
@@ -191,7 +189,7 @@ static int actisys_change_speed(struct s
 	}
 
 	/* Check if life is sweet... */
-	if (i >= MAX_SPEEDS) {
+	if (i >= ARRAY_SIZE(baud_rates)) {
 		actisys_reset(dev);
 		ret = -EINVAL;  /* This should not happen */
 	}
diff -puN drivers/net/sk98lin/skgemib.c~removes-array_size-duplicates drivers/net/sk98lin/skgemib.c
--- a/drivers/net/sk98lin/skgemib.c~removes-array_size-duplicates
+++ a/drivers/net/sk98lin/skgemib.c
@@ -80,11 +80,6 @@ PNMI_STATIC int DiagActions(SK_AC *pAC, 
 	unsigned int TableIndex, SK_U32 NetIndex);
 #endif /* SK_DIAG_SUPPORT */
 
-
-/* defines *******************************************************************/
-#define ID_TABLE_SIZE (sizeof(IdTable)/sizeof(IdTable[0]))
-
-
 /* global variables **********************************************************/
 
 /*
diff -puN drivers/net/skfp/smt.c~removes-array_size-duplicates drivers/net/skfp/smt.c
--- a/drivers/net/skfp/smt.c~removes-array_size-duplicates
+++ a/drivers/net/skfp/smt.c
@@ -1654,8 +1654,6 @@ static const struct smt_pdef {
 	{ SMT_P4053,	0,	SWAP_SMT_P4053			} ,
 } ;
 
-#define N_SMT_PLEN	ARRAY_SIZE(smt_pdef)
-
 int smt_check_para(struct s_smc *smc, struct smt_header	*sm,
 		   const u_short list[])
 {
@@ -1881,7 +1879,7 @@ void smt_swap_para(struct smt_header *sm
 		if (plen < 0)
 			break ;
 		plen += PARA_LEN ;
-		for (i = N_SMT_PLEN, pd = smt_pdef; i ; i--,pd++) {
+		for (i = ARRAY_SIZE(smt_pdef), pd = smt_pdef; i ; i--,pd++) {
 			if (pd->ptype == type)
 				break ;
 		}
diff -puN drivers/net/skfp/srf.c~removes-array_size-duplicates drivers/net/skfp/srf.c
--- a/drivers/net/skfp/srf.c~removes-array_size-duplicates
+++ a/drivers/net/skfp/srf.c
@@ -43,8 +43,6 @@ static void clear_reported(struct s_smc 
 static void smt_send_srf(struct s_smc *smc);
 static struct s_srf_evc *smt_get_evc(struct s_smc *smc, int code, int index);
 
-#define MAX_EVCS	ARRAY_SIZE(smc->evcs)
-
 struct evc_init {
 	u_char code ;
 	u_char index ;
@@ -84,7 +82,7 @@ void smt_init_evc(struct s_smc *smc)
 	evc = smc->evcs ;
 	init = evc_inits ;
 
-	for (i = 0 ; (unsigned) i < MAX_INIT_EVC ; i++) {
+	for (i = 0 ; (unsigned) i < ARRAY_SIZE(evc_inits) ; i++) {
 		for (index = 0 ; index < init->n ; index++) {
 			evc->evc_code = init->code ;
 			evc->evc_para = init->para ;
@@ -98,7 +96,7 @@ void smt_init_evc(struct s_smc *smc)
 		init++ ;
 	}
 
-	if ((unsigned) (evc - smc->evcs) > MAX_EVCS) {
+	if ((unsigned) (evc - smc->evcs) > ARRAY_SIZE(smc->evcs)) {
 		SMT_PANIC(smc,SMT_E0127, SMT_E0127_MSG) ;
 	}
 
@@ -139,7 +137,7 @@ void smt_init_evc(struct s_smc *smc)
 		offset++ ;
 	}
 #ifdef	DEBUG
-	for (i = 0, evc = smc->evcs ; (unsigned) i < MAX_EVCS ; i++, evc++) {
+	for (i = 0, evc = smc->evcs ; (unsigned) i < ARRAY_SIZE(smc->evcs) ; i++, evc++) {
 		if (SMT_IS_CONDITION(evc->evc_code)) {
 			if (!evc->evc_cond_state) {
 				SMT_PANIC(smc,SMT_E0128, SMT_E0128_MSG) ;
@@ -163,7 +161,7 @@ static struct s_srf_evc *smt_get_evc(str
 	int			i ;
 	struct s_srf_evc	*evc ;
 
-	for (i = 0, evc = smc->evcs ; (unsigned) i < MAX_EVCS ; i++, evc++) {
+	for (i = 0, evc = smc->evcs ; (unsigned) i < ARRAY_SIZE(smc->evcs) ; i++, evc++) {
 		if (evc->evc_code == code && evc->evc_index == index)
 			return(evc) ;
 	}
@@ -337,7 +335,7 @@ static void clear_all_rep(struct s_smc *
 	struct s_srf_evc	*evc ;
 	int			i ;
 
-	for (i = 0, evc = smc->evcs ; (unsigned) i < MAX_EVCS ; i++, evc++) {
+	for (i = 0, evc = smc->evcs ; (unsigned) i < ARRAY_SIZE(smc->evcs) ; i++, evc++) {
 		evc->evc_rep_required = FALSE ;
 		if (SMT_IS_CONDITION(evc->evc_code))
 			*evc->evc_cond_state = FALSE ;
@@ -351,7 +349,7 @@ static void clear_reported(struct s_smc 
 	int			i ;
 
 	smc->srf.any_report = FALSE ;
-	for (i = 0, evc = smc->evcs ; (unsigned) i < MAX_EVCS ; i++, evc++) {
+	for (i = 0, evc = smc->evcs ; (unsigned) i < ARRAY_SIZE(smc->evcs) ; i++, evc++) {
 		if (SMT_IS_CONDITION(evc->evc_code)) {
 			if (*evc->evc_cond_state == FALSE)
 				evc->evc_rep_required = FALSE ;
@@ -405,7 +403,7 @@ static void smt_send_srf(struct s_smc *s
 	smt_add_para(smc,&pcon,(u_short) SMT_P1033,0,0) ;
 	smt_add_para(smc,&pcon,(u_short) SMT_P1034,0,0) ;
 
-	for (i = 0, evc = smc->evcs ; (unsigned) i < MAX_EVCS ; i++, evc++) {
+	for (i = 0, evc = smc->evcs ; (unsigned) i < ARRAY_SIZE(smc->evcs) ; i++, evc++) {
 		if (evc->evc_rep_required) {
 			smt_add_para(smc,&pcon,evc->evc_para,
 				(int)evc->evc_index,0) ;
diff -puN drivers/net/wireless/ipw2100.c~removes-array_size-duplicates drivers/net/wireless/ipw2100.c
--- a/drivers/net/wireless/ipw2100.c~removes-array_size-duplicates
+++ a/drivers/net/wireless/ipw2100.c
@@ -6582,9 +6582,6 @@ static const long ipw2100_frequencies[] 
 	2472, 2484
 };
 
-#define FREQ_COUNT (sizeof(ipw2100_frequencies) / \
-                    sizeof(ipw2100_frequencies[0]))
-
 static const long ipw2100_rates_11b[] = {
 	1000000,
 	2000000,
@@ -6592,8 +6589,6 @@ static const long ipw2100_rates_11b[] = 
 	11000000
 };
 
-#define RATE_COUNT ARRAY_SIZE(ipw2100_rates_11b)
-
 static int ipw2100_wx_get_name(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
@@ -6798,9 +6793,9 @@ static int ipw2100_wx_get_range(struct n
 	range->avg_qual.noise = 0;
 	range->avg_qual.updated = 7;	/* Updated all three */
 
-	range->num_bitrates = RATE_COUNT;
+	range->num_bitrates = ARRAY_SIZE(ipw2100_rates);
 
-	for (i = 0; i < RATE_COUNT && i < IW_MAX_BITRATES; i++) {
+	for (i = 0; i < ARRAY_SIZE(ipw2100_rates) && i < IW_MAX_BITRATES; i++) {
 		range->bitrate[i] = ipw2100_rates_11b[i];
 	}
 
@@ -6853,10 +6848,10 @@ static int ipw2100_wx_get_range(struct n
 //      range->min_r_time;      /* Minimal retry lifetime */
 //      range->max_r_time;      /* Maximal retry lifetime */
 
-	range->num_channels = FREQ_COUNT;
+	range->num_channels = ARRAY_SIZE(ipw2100_frequencies);
 
 	val = 0;
-	for (i = 0; i < FREQ_COUNT; i++) {
+	for (i = 0; i < ARRAY_SIZE(ipw2100_frequencies); i++) {
 		// TODO: Include only legal frequencies for some countries
 //              if (local->channel_mask & (1 << i)) {
 		range->freq[val].i = i + 1;
diff -puN drivers/serial/68328serial.c~removes-array_size-duplicates drivers/serial/68328serial.c
--- a/drivers/serial/68328serial.c~removes-array_size-duplicates
+++ a/drivers/serial/68328serial.c
@@ -157,8 +157,6 @@ static int baud_table[] = {
 	0, 50, 75, 110, 134, 150, 200, 300, 600, 1200, 1800, 2400, 4800,
 	9600, 19200, 38400, 57600, 115200, 0 };
 
-#define BAUD_TABLE_SIZE (sizeof(baud_table)/sizeof(baud_table[0]))
-
 /* Sets or clears DTR/RTS on the requested line */
 static inline void m68k_rtsdtr(struct m68k_serial *ss, int set)
 {
@@ -1460,10 +1458,10 @@ int m68328_console_setup(struct console 
 	if (arg)
 		n = simple_strtoul(arg,NULL,0);
 
-	for (i = 0; i < BAUD_TABLE_SIZE; i++)
+	for (i = 0; i < ARRAY_SIZE(baud_table); i++)
 		if (baud_table[i] == n)
 			break;
-	if (i < BAUD_TABLE_SIZE) {
+	if (i < ARRAY_SIZE(baud_table)) {
 		m68328_console_baud = n;
 		m68328_console_cbaud = 0;
 		if (i > 15) {
diff -puN drivers/video/sgivwfb.c~removes-array_size-duplicates drivers/video/sgivwfb.c
--- a/drivers/video/sgivwfb.c~removes-array_size-duplicates
+++ a/drivers/video/sgivwfb.c
@@ -261,13 +261,13 @@ static int sgivwfb_check_var(struct fb_v
 	var->grayscale = 0;	/* No grayscale for now */
 
 	/* determine valid resolution and timing */
-	for (min_mode = 0; min_mode < DBE_VT_SIZE; min_mode++) {
+	for (min_mode = 0; min_mode < ARRAY_SIZE(dbeVTimings); min_mode++) {
 		if (dbeVTimings[min_mode].width >= var->xres &&
 		    dbeVTimings[min_mode].height >= var->yres)
 			break;
 	}
 
-	if (min_mode == DBE_VT_SIZE)
+	if (min_mode == ARRAY_SIZE(dbeVTimings))
 		return -EINVAL;	/* Resolution to high */
 
 	/* XXX FIXME - should try to pick best refresh rate */
diff -puN include/acpi/acmacros.h~removes-array_size-duplicates include/acpi/acmacros.h
--- a/include/acpi/acmacros.h~removes-array_size-duplicates
+++ a/include/acpi/acmacros.h
@@ -59,8 +59,6 @@
 
 /* Size calculation */
 
-#define ACPI_ARRAY_LENGTH(x)            (sizeof(x) / sizeof((x)[0]))
-
 #ifdef ACPI_NO_INTEGER64_SUPPORT
 /*
  * acpi_integer is 32-bits, no 64-bit support on this platform
diff -puN include/linux/netfilter/xt_sctp.h~removes-array_size-duplicates include/linux/netfilter/xt_sctp.h
--- a/include/linux/netfilter/xt_sctp.h~removes-array_size-duplicates
+++ a/include/linux/netfilter/xt_sctp.h
@@ -7,8 +7,6 @@
 
 #define XT_SCTP_VALID_FLAGS		0x07
 
-#define ELEMCOUNT(x) (sizeof(x)/sizeof(x[0]))
-
 
 struct xt_sctp_flag_info {
 	u_int8_t chunktype;
@@ -59,21 +57,21 @@ struct xt_sctp_info {
 #define SCTP_CHUNKMAP_RESET(chunkmap) 				\
 	do {							\
 		int i; 						\
-		for (i = 0; i < ELEMCOUNT(chunkmap); i++)	\
+		for (i = 0; i < ARRAY_SIZE(chunkmap); i++)	\
 			chunkmap[i] = 0;			\
 	} while (0)
 
 #define SCTP_CHUNKMAP_SET_ALL(chunkmap) 			\
 	do {							\
 		int i; 						\
-		for (i = 0; i < ELEMCOUNT(chunkmap); i++) 	\
+		for (i = 0; i < ARRAY_SIZE(chunkmap); i++) 	\
 			chunkmap[i] = ~0;			\
 	} while (0)
 
 #define SCTP_CHUNKMAP_COPY(destmap, srcmap) 			\
 	do {							\
 		int i; 						\
-		for (i = 0; i < ELEMCOUNT(chunkmap); i++) 	\
+		for (i = 0; i < ARRAY_SIZE(chunkmap); i++) 	\
 			destmap[i] = srcmap[i];			\
 	} while (0)
 
@@ -81,7 +79,7 @@ struct xt_sctp_info {
 ({							\
 	int i; 						\
 	int flag = 1;					\
-	for (i = 0; i < ELEMCOUNT(chunkmap); i++) {	\
+	for (i = 0; i < ARRAY_SIZE(chunkmap); i++) {	\
 		if (chunkmap[i]) {			\
 			flag = 0;			\
 			break;				\
@@ -94,7 +92,7 @@ struct xt_sctp_info {
 ({							\
 	int i; 						\
 	int flag = 1;					\
-	for (i = 0; i < ELEMCOUNT(chunkmap); i++) {	\
+	for (i = 0; i < ARRAY_SIZE(chunkmap); i++) {	\
 		if (chunkmap[i] != ~0) {		\
 			flag = 0;			\
 				break;			\
diff -puN include/net/ip_vs.h~removes-array_size-duplicates include/net/ip_vs.h
--- a/include/net/ip_vs.h~removes-array_size-duplicates
+++ a/include/net/ip_vs.h
@@ -704,7 +704,6 @@ struct ip_vs_app
  */
 extern const char *ip_vs_proto_name(unsigned proto);
 extern void ip_vs_init_hash_table(struct list_head *table, int rows);
-#define IP_VS_INIT_HASH_TABLE(t) ip_vs_init_hash_table(t, sizeof(t)/sizeof(t[0]))
 
 #define IP_VS_APP_TYPE_UNSPEC	0
 #define IP_VS_APP_TYPE_FTP	1
diff -puN include/video/sgivw.h~removes-array_size-duplicates include/video/sgivw.h
--- a/include/video/sgivw.h~removes-array_size-duplicates
+++ a/include/video/sgivw.h
@@ -676,7 +676,6 @@ struct dbe_timing_info dbeVTimings[] = {
   }
 };
 
-#define DBE_VT_SIZE  (sizeof(dbeVTimings)/sizeof(dbeVTimings[0]))
 #endif // INCLUDE_TIMING_TABLE_DATA
 
 #endif // ! __SGIVWFB_H__
diff -puN net/ipv4/ipvs/ip_vs_proto_tcp.c~removes-array_size-duplicates net/ipv4/ipvs/ip_vs_proto_tcp.c
--- a/net/ipv4/ipvs/ip_vs_proto_tcp.c~removes-array_size-duplicates
+++ a/net/ipv4/ipvs/ip_vs_proto_tcp.c
@@ -584,7 +584,7 @@ void ip_vs_tcp_conn_listen(struct ip_vs_
 
 static void ip_vs_tcp_init(struct ip_vs_protocol *pp)
 {
-	IP_VS_INIT_HASH_TABLE(tcp_apps);
+	ip_vs_init_hash_table(tcp_apps, ARRAY_SIZE(tcp_apps));
 	pp->timeout_table = tcp_timeouts;
 }
 
diff -puN scripts/mod/file2alias.c~removes-array_size-duplicates scripts/mod/file2alias.c
--- a/scripts/mod/file2alias.c~removes-array_size-duplicates
+++ a/scripts/mod/file2alias.c
@@ -414,8 +414,6 @@ static int do_vio_entry(const char *file
 	return 1;
 }
 
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
-
 static void do_input(char *alias,
 		     kernel_ulong_t *arr, unsigned int min, unsigned int max)
 {
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

spin_lock_unlocked-cleanups.patch
removes-array_size-duplicates.patch
