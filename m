From: akpm@linux-foundation.org
Subject: - add-section-ids-to-mtdnandtmpl.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:02:04 -0800
Message-ID: <200802080801.m1881jmR013986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38175 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754747AbYBHIBx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:01:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@landley.net, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Add section IDs to mtdnand.tmpl
has been removed from the -mm tree.  Its filename was
     add-section-ids-to-mtdnandtmpl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add section IDs to mtdnand.tmpl
From: Rob Landley <rob@landley.net>

Add section IDs to mtdnand.tmpl

Signed-off-by: Rob Landley <rob@landley.net>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/mtdnand.tmpl |   58 +++++++++++++--------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff -puN Documentation/DocBook/mtdnand.tmpl~add-section-ids-to-mtdnandtmpl Documentation/DocBook/mtdnand.tmpl
--- a/Documentation/DocBook/mtdnand.tmpl~add-section-ids-to-mtdnandtmpl
+++ a/Documentation/DocBook/mtdnand.tmpl
@@ -80,7 +80,7 @@
      struct member has a short description which is marked with an [XXX] identifier.
      The following chapters explain the meaning of those identifiers.
      </para>
-     <sect1>   
+     <sect1 id="Function_identifiers_XXX">
 	<title>Function identifiers [XXX]</title>
      	<para>
 	The functions are marked with [XXX] identifiers in the short
@@ -115,7 +115,7 @@
 		</para></listitem>
 	</itemizedlist>
      </sect1>
-     <sect1>   
+     <sect1 id="Struct_member_identifiers_XXX">
 	<title>Struct member identifiers [XXX]</title>
      	<para>
 	The struct members are marked with [XXX] identifiers in the 
@@ -159,7 +159,7 @@
 		basic functions and fill out some really board dependent
 		members in the nand chip description structure.
 	</para>
-	<sect1>
+	<sect1 id="Basic_defines">
 		<title>Basic defines</title>
 		<para>
 			At least you have to provide a mtd structure and
@@ -185,7 +185,7 @@ static struct nand_chip board_chip;
 static unsigned long baseaddr;
 		</programlisting>
 	</sect1>
-	<sect1>
+	<sect1 id="Partition_defines">
 		<title>Partition defines</title>
 		<para>
 			If you want to divide your device into partitions, then
@@ -204,7 +204,7 @@ static struct mtd_partition partition_in
 };
 		</programlisting>
 	</sect1>
-	<sect1>
+	<sect1 id="Hardware_control_functions">
 		<title>Hardware control function</title>
 		<para>
 			The hardware control function provides access to the 
@@ -246,7 +246,7 @@ static void board_hwcontrol(struct mtd_i
 }
 		</programlisting>
 	</sect1>
-	<sect1>
+	<sect1 id="Device_ready_function">
 		<title>Device ready function</title>
 		<para>
 			If the hardware interface has the ready busy pin of the NAND chip connected to a
@@ -257,7 +257,7 @@ static void board_hwcontrol(struct mtd_i
 			the function must not be defined and the function pointer this->dev_ready is set to NULL.		
 		</para>
 	</sect1>
-	<sect1>
+	<sect1 id="Init_function">
 		<title>Init function</title>
 		<para>
 			The init function allocates memory and sets up all the board
@@ -325,7 +325,7 @@ out:
 module_init(board_init);
 		</programlisting>
 	</sect1>
-	<sect1>
+	<sect1 id="Exit_function">
 		<title>Exit function</title>
 		<para>
 			The exit function is only neccecary if the driver is
@@ -359,7 +359,7 @@ module_exit(board_cleanup);
 		driver. For a list of functions which can be overridden by the board
 		driver see the documentation of the nand_chip structure.
 	</para>
-	<sect1>
+	<sect1 id="Multiple_chip_control">
 		<title>Multiple chip control</title>
 		<para>
 			The nand driver can control chip arrays. Therefor the
@@ -419,9 +419,9 @@ static void board_select_chip (struct mt
 }
 		</programlisting>
 	</sect1>
-	<sect1>
+	<sect1 id="Hardware_ECC_support">
 		<title>Hardware ECC support</title>
-		<sect2>
+		<sect2 id="Functions_and_constants">
 			<title>Functions and constants</title>
 			<para>
 				The nand driver supports three different types of
@@ -475,7 +475,7 @@ static void board_select_chip (struct mt
 				</itemizedlist>
 			</para>
 		</sect2>
-		<sect2>
+		<sect2 id="Hardware_ECC_with_syndrome_calculation">
 		<title>Hardware ECC with syndrome calculation</title>
 			<para>
 				Many hardware ECC implementations provide Reed-Solomon
@@ -500,7 +500,7 @@ static void board_select_chip (struct mt
 			</para>
 		</sect2>
 	</sect1>
-	<sect1>
+	<sect1 id="Bad_Block_table_support">
 		<title>Bad block table support</title>
 		<para>
 			Most NAND chips mark the bad blocks at a defined
@@ -552,7 +552,7 @@ static void board_select_chip (struct mt
 			allows faster access than always checking the
 			bad block information on the flash chip itself.
 		</para>
-		<sect2>
+		<sect2 id="Flash_based_tables">
 			<title>Flash based tables</title>
 			<para>
 				It may be desired or neccecary to keep a bad block table in FLASH. 
@@ -587,7 +587,7 @@ static void board_select_chip (struct mt
 				</itemizedlist>
 			</para>
 		</sect2>
-		<sect2>
+		<sect2 id="User_defined_tables">
 			<title>User defined tables</title>
 			<para>
 				User defined tables are created by filling out a 
@@ -676,7 +676,7 @@ static void board_select_chip (struct mt
 			</para>
 		</sect2>
 	</sect1>
-	<sect1>
+	<sect1 id="Spare_area_placement">
 		<title>Spare area (auto)placement</title>
 		<para>
 			The nand driver implements different possibilities for
@@ -730,7 +730,7 @@ struct nand_oobinfo {
 			</para></listitem>
 			</itemizedlist>
 		</para>
-		<sect2>
+		<sect2 id="Placement_defined_by_fs_driver">
 			<title>Placement defined by fs driver</title>
 			<para>
 				The calling function provides a pointer to a nand_oobinfo
@@ -760,7 +760,7 @@ struct nand_oobinfo {
 				done according to the given scheme in the nand_oobinfo structure.
 			</para>
 		</sect2>
-		<sect2>
+		<sect2 id="Automatic_placement">
 			<title>Automatic placement</title>
 			<para>
 				Automatic placement uses the built in defaults to place the
@@ -774,7 +774,7 @@ struct nand_oobinfo {
 				done according to the default builtin scheme.
 			</para>
 		</sect2>
-		<sect2>
+		<sect2 id="User_space_placement_selection">
 			<title>User space placement selection</title>
 		<para>
 			All non ecc functions like mtd->read and mtd->write use an internal 
@@ -789,9 +789,9 @@ struct nand_oobinfo {
 		</para>
 		</sect2>
 	</sect1>	
-	<sect1>
+	<sect1 id="Spare_area_autoplacement_default">
 		<title>Spare area autoplacement default schemes</title>
-		<sect2>
+		<sect2 id="pagesize_256">
 			<title>256 byte pagesize</title>
 <informaltable><tgroup cols="3"><tbody>
 <row>
@@ -843,7 +843,7 @@ pages this byte is reserved</entry>
 </row>
 </tbody></tgroup></informaltable>
 		</sect2>
-		<sect2>
+		<sect2 id="pagesize_512">
 			<title>512 byte pagesize</title>
 <informaltable><tgroup cols="3"><tbody>
 <row>
@@ -906,7 +906,7 @@ in this page</entry>
 </row>
 </tbody></tgroup></informaltable>
 		</sect2>
-		<sect2>
+		<sect2 id="pagesize_2048">
 			<title>2048 byte pagesize</title>
 <informaltable><tgroup cols="3"><tbody>
 <row>
@@ -1126,9 +1126,9 @@ in this page</entry>
      <para>
      This chapter describes the constants which might be relevant for a driver developer.
      </para>
-     <sect1>   
+     <sect1 id="Chip_option_constants">
 	<title>Chip option constants</title>
-     	<sect2>   
+     	<sect2 id="Constants_for_chip_id_table">
 		<title>Constants for chip id table</title>
      		<para>
 		These constants are defined in nand.h. They are ored together to describe
@@ -1153,7 +1153,7 @@ in this page</entry>
 		</programlisting>
      		</para>
      	</sect2>
-     	<sect2>   
+     	<sect2 id="Constants_for_runtime_options">
 		<title>Constants for runtime options</title>
      		<para>
 		These constants are defined in nand.h. They are ored together to describe
@@ -1171,7 +1171,7 @@ in this page</entry>
      	</sect2>
      </sect1>	
 
-     <sect1>   
+     <sect1 id="EEC_selection_constants">
 	<title>ECC selection constants</title>
 	<para>
 	Use these constants to select the ECC algorithm.
@@ -1192,7 +1192,7 @@ in this page</entry>
 	</para>
      </sect1>	
 
-     <sect1>   
+     <sect1 id="Hardware_control_related_constants">
 	<title>Hardware control related constants</title>
 	<para>
 	These constants describe the requested hardware access function when
@@ -1218,7 +1218,7 @@ in this page</entry>
 	</para>
      </sect1>	
 
-     <sect1>   
+     <sect1 id="Bad_block_table_constants">
 	<title>Bad block table related constants</title>
 	<para>
 	These constants describe the options used for bad block
_

Patches currently in -mm which might be from rob@landley.net are

origin.patch
irq_noprobe-helper-functions.patch
mips-mark-all-but-i8259-interrupts-as-no-probe.patch
