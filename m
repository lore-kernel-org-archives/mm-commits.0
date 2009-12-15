From: akpm@linux-foundation.org
Subject: [merged] page-types-learn-to-describe-flags-directly-from-command-line.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:50:13 -0800
Message-ID: <200912152150.nBFLoDxx014932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755768AbZLOWSL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:18:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: achiang@hp.com, andi@firstfloor.org, fengguang.wu@intel.com, haicheng.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     page-types: learn to describe flags directly from command line
has been removed from the -mm tree.  Its filename was
     page-types-learn-to-describe-flags-directly-from-command-line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-types: learn to describe flags directly from command line
From: Alex Chiang <achiang@hp.com>

Teach page-types to describe page flags directly from the command line.

Why is this useful?  For instance, if you're using memory hotplug and see
this in /var/log/messages:

	kernel: removing from LRU failed 3836dd0/1/1e00000000000010

It would be nice to decode those page flags without staring at the source.

Example usage and output:

# Documentation/vm/page-types -d 0x10
0x0000000000000010	____D_____________________________	dirty

# Documentation/vm/page-types -d anon
0x0000000000001000	____________a_____________________	anonymous

# Documentation/vm/page-types -d anon,0x10
0x0000000000001010	____D_______a_____________________	dirty,anonymous

[achiang@hp.com: documentation]
Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Haicheng Li <haicheng.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page-types.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff -puN Documentation/vm/page-types.c~page-types-learn-to-describe-flags-directly-from-command-line Documentation/vm/page-types.c
--- a/Documentation/vm/page-types.c~page-types-learn-to-describe-flags-directly-from-command-line
+++ a/Documentation/vm/page-types.c
@@ -674,6 +674,7 @@ static void usage(void)
 	printf(
 "page-types [options]\n"
 "            -r|--raw                  Raw mode, for kernel developers\n"
+"            -d|--describe flags        Describe flags\n"
 "            -a|--addr    addr-spec    Walk a range of pages\n"
 "            -b|--bits    bits-spec    Walk pages with specified bits\n"
 "            -p|--pid     pid          Walk process address space\n"
@@ -686,6 +687,10 @@ static void usage(void)
 "            -X|--hwpoison             hwpoison pages\n"
 "            -x|--unpoison             unpoison pages\n"
 "            -h|--help                 Show this usage message\n"
+"flags:\n"
+"            0x10                      bitfield format, e.g.\n"
+"            anon                      bit-name, e.g.\n"
+"            0x10,anon                 comma-separated list, e.g.\n"
 "addr-spec:\n"
 "            N                         one page at offset N (unit: pages)\n"
 "            N+M                       pages range from N to N+M-1\n"
@@ -884,6 +889,15 @@ static void parse_bits_mask(const char *
 	add_bits_filter(mask, bits);
 }
 
+static void describe_flags(const char *optarg)
+{
+	uint64_t flags = parse_flag_names(optarg, 0);
+
+	printf("0x%016llx\t%s\t%s\n",
+		(unsigned long long)flags,
+		page_flag_name(flags),
+		page_flag_longname(flags));
+}
 
 static const struct option opts[] = {
 	{ "raw"       , 0, NULL, 'r' },
@@ -891,6 +905,7 @@ static const struct option opts[] = {
 	{ "file"      , 1, NULL, 'f' },
 	{ "addr"      , 1, NULL, 'a' },
 	{ "bits"      , 1, NULL, 'b' },
+	{ "describe"  , 1, NULL, 'd' },
 	{ "list"      , 0, NULL, 'l' },
 	{ "list-each" , 0, NULL, 'L' },
 	{ "no-summary", 0, NULL, 'N' },
@@ -907,7 +922,7 @@ int main(int argc, char *argv[])
 	page_size = getpagesize();
 
 	while ((c = getopt_long(argc, argv,
-				"rp:f:a:b:lLNXxh", opts, NULL)) != -1) {
+				"rp:f:a:b:d:lLNXxh", opts, NULL)) != -1) {
 		switch (c) {
 		case 'r':
 			opt_raw = 1;
@@ -924,6 +939,10 @@ int main(int argc, char *argv[])
 		case 'b':
 			parse_bits_mask(optarg);
 			break;
+		case 'd':
+			opt_no_summary = 1;
+			describe_flags(optarg);
+			break;
 		case 'l':
 			opt_list = 1;
 			break;
_

Patches currently in -mm which might be from achiang@hp.com are

origin.patch
linux-next.patch

