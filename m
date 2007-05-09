From: akpm@linux-foundation.org
Subject: - scripts-kernel-doc-whitespace-cleanup.patch removed from -mm tree
Date: Tue, 08 May 2007 19:44:59 -0700
Message-ID: <200705090244.l492ixjX008665@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58522 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969211AbXEICpM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:45:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     scripts: kernel-doc whitespace cleanup
has been removed from the -mm tree.  Its filename was
     scripts-kernel-doc-whitespace-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: scripts: kernel-doc whitespace cleanup
From: Randy Dunlap <randy.dunlap@oracle.com>

Whitespace cleanup only:  convert some series of spaces to tabs.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |   96 +++++++++++++++++++++----------------------
 1 file changed, 48 insertions(+), 48 deletions(-)

diff -puN scripts/kernel-doc~scripts-kernel-doc-whitespace-cleanup scripts/kernel-doc
--- a/scripts/kernel-doc~scripts-kernel-doc-whitespace-cleanup
+++ a/scripts/kernel-doc
@@ -381,10 +381,10 @@ sub output_highlight {
     eval $dohighlight;
     die $@ if $@;
     foreach $line (split "\n", $contents) {
-      if ($line eq ""){
+	if ($line eq ""){
 	    print $lineprefix, $blankline;
 	} else {
-            $line =~ s/\\\\\\/\&/g;
+	    $line =~ s/\\\\\\/\&/g;
 	    print $lineprefix, $line;
 	}
 	print "\n";
@@ -414,7 +414,7 @@ sub output_enum_html(%) {
     print "<b>enum ".$args{'enum'}."</b> {<br>\n";
     $count = 0;
     foreach $parameter (@{$args{'parameterlist'}}) {
-        print " <b>".$parameter."</b>";
+	print " <b>".$parameter."</b>";
 	if ($count != $#{$args{'parameterlist'}}) {
 	    $count++;
 	    print ",\n";
@@ -462,7 +462,7 @@ sub output_struct_html(%) {
 	my $parameter_name = $parameter;
 	$parameter_name =~ s/\[.*//;
 
-        ($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
+	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
 	$type = $args{'parametertypes'}{$parameter};
 	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
 	    # pointer-to-function
@@ -483,7 +483,7 @@ sub output_struct_html(%) {
 	my $parameter_name = $parameter;
 	$parameter_name =~ s/\[.*//;
 
-        ($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
+	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
 	print "<dt><b>".$parameter."</b>\n";
 	print "<dd>";
 	output_highlight($args{'parameterdescs'}{$parameter_name});
@@ -525,7 +525,7 @@ sub output_function_html(%) {
 	my $parameter_name = $parameter;
 	$parameter_name =~ s/\[.*//;
 
-        ($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
+	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
 	print "<dt><b>".$parameter."</b>\n";
 	print "<dd>";
 	output_highlight($args{'parameterdescs'}{$parameter_name});
@@ -691,7 +691,7 @@ sub output_struct_xml(%) {
 	$parameter_name =~ s/\[.*//;
 
 	defined($args{'parameterdescs'}{$parameter_name}) || next;
-        ($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
+	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
 	$type = $args{'parametertypes'}{$parameter};
 	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
 	    # pointer-to-function
@@ -767,11 +767,11 @@ sub output_enum_xml(%) {
     print "enum ".$args{'enum'}." {\n";
     $count = 0;
     foreach $parameter (@{$args{'parameterlist'}}) {
-        print "  $parameter";
-        if ($count != $#{$args{'parameterlist'}}) {
+	print "  $parameter";
+	if ($count != $#{$args{'parameterlist'}}) {
 	    $count++;
 	    print ",";
-        }
+	}
 	print "\n";
     }
     print "};";
@@ -1007,7 +1007,7 @@ sub output_enum_man(%) {
     print "enum ".$args{'enum'}." {\n";
     $count = 0;
     foreach my $parameter (@{$args{'parameterlist'}}) {
-        print ".br\n.BI \"    $parameter\"\n";
+	print ".br\n.BI \"    $parameter\"\n";
 	if ($count == $#{$args{'parameterlist'}}) {
 	    print "\n};\n";
 	    last;
@@ -1054,7 +1054,7 @@ sub output_struct_man(%) {
 	my $parameter_name = $parameter;
 	$parameter_name =~ s/\[.*//;
 
-        ($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
+	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
 	$type = $args{'parametertypes'}{$parameter};
 	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
 	    # pointer-to-function
@@ -1077,7 +1077,7 @@ sub output_struct_man(%) {
 	my $parameter_name = $parameter;
 	$parameter_name =~ s/\[.*//;
 
-        ($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
+	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
 	print ".IP \"".$parameter."\" 12\n";
 	output_highlight($args{'parameterdescs'}{$parameter_name});
     }
@@ -1187,7 +1187,7 @@ sub output_enum_text(%) {
     print "enum ".$args{'enum'}." {\n";
     $count = 0;
     foreach $parameter (@{$args{'parameterlist'}}) {
-        print "\t$parameter";
+	print "\t$parameter";
 	if ($count != $#{$args{'parameterlist'}}) {
 	    $count++;
 	    print ",";
@@ -1232,7 +1232,7 @@ sub output_struct_text(%) {
 	my $parameter_name = $parameter;
 	$parameter_name =~ s/\[.*//;
 
-        ($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
+	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
 	$type = $args{'parametertypes'}{$parameter};
 	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
 	    # pointer-to-function
@@ -1252,7 +1252,7 @@ sub output_struct_text(%) {
 	my $parameter_name = $parameter;
 	$parameter_name =~ s/\[.*//;
 
-        ($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
+	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
 	print "$parameter\n\t";
 	print $args{'parameterdescs'}{$parameter_name}."\n";
     }
@@ -1284,7 +1284,7 @@ sub output_declaration {
 	( $function_only == 1 && defined($function_table{$name})) ||
 	( $function_only == 2 && !defined($function_table{$name})))
     {
-        &$func(@_);
+	&$func(@_);
 	$section_counter++;
     }
 }
@@ -1317,8 +1317,8 @@ sub dump_struct($$) {
     my $file = shift;
 
     if ($x =~/(struct|union)\s+(\w+)\s*{(.*)}/) {
-        $declaration_name = $2;
-        my $members = $3;
+	$declaration_name = $2;
+	my $members = $3;
 
 	# ignore embedded structs or unions
 	$members =~ s/{.*?}//g;
@@ -1345,7 +1345,7 @@ sub dump_struct($$) {
 			   });
     }
     else {
-        print STDERR "Error(${file}:$.): Cannot parse struct or union!\n";
+	print STDERR "Error(${file}:$.): Cannot parse struct or union!\n";
 	++$errors;
     }
 }
@@ -1356,15 +1356,15 @@ sub dump_enum($$) {
 
     $x =~ s@/\*.*?\*/@@gos;	# strip comments.
     if ($x =~ /enum\s+(\w+)\s*{(.*)}/) {
-        $declaration_name = $1;
-        my $members = $2;
+	$declaration_name = $1;
+	my $members = $2;
 
 	foreach my $arg (split ',', $members) {
 	    $arg =~ s/^\s*(\w+).*/$1/;
 	    push @parameterlist, $arg;
 	    if (!$parameterdescs{$arg}) {
-	        $parameterdescs{$arg} = $undescribed;
-	        print STDERR "Warning(${file}:$.): Enum value '$arg' ".
+		$parameterdescs{$arg} = $undescribed;
+		print STDERR "Warning(${file}:$.): Enum value '$arg' ".
 		    "not described in enum '$declaration_name'\n";
 	    }
 
@@ -1382,7 +1382,7 @@ sub dump_enum($$) {
 			   });
     }
     else {
-        print STDERR "Error(${file}:$.): Cannot parse enum!\n";
+	print STDERR "Error(${file}:$.): Cannot parse enum!\n";
 	++$errors;
     }
 }
@@ -1393,12 +1393,12 @@ sub dump_typedef($$) {
 
     $x =~ s@/\*.*?\*/@@gos;	# strip comments.
     while (($x =~ /\(*.\)\s*;$/) || ($x =~ /\[*.\]\s*;$/)) {
-        $x =~ s/\(*.\)\s*;$/;/;
+	$x =~ s/\(*.\)\s*;$/;/;
 	$x =~ s/\[*.\]\s*;$/;/;
     }
 
     if ($x =~ /typedef.*\s+(\w+)\s*;/) {
-        $declaration_name = $1;
+	$declaration_name = $1;
 
 	output_declaration($declaration_name,
 			   'typedef',
@@ -1410,7 +1410,7 @@ sub dump_typedef($$) {
 			   });
     }
     else {
-        print STDERR "Error(${file}:$.): Cannot parse typedef!\n";
+	print STDERR "Error(${file}:$.): Cannot parse typedef!\n";
 	++$errors;
     }
 }
@@ -1424,14 +1424,14 @@ sub create_parameterlist($$$) {
 
     # temporarily replace commas inside function pointer definition
     while ($args =~ /(\([^\),]+),/) {
-        $args =~ s/(\([^\),]+),/$1#/g;
+	$args =~ s/(\([^\),]+),/$1#/g;
     }
 
     foreach my $arg (split($splitter, $args)) {
 	# strip comments
 	$arg =~ s/\/\*.*\*\///;
-        # strip leading/trailing spaces
-        $arg =~ s/^\s*//;
+	# strip leading/trailing spaces
+	$arg =~ s/^\s*//;
 	$arg =~ s/\s*$//;
 	$arg =~ s/\s+/ /;
 
@@ -1514,15 +1514,15 @@ sub push_parameter($$$) {
 	    $parameterdescs{$param_name} = $undescribed;
 
 	    if (($type eq 'function') || ($type eq 'enum')) {
-	        print STDERR "Warning(${file}:$.): Function parameter ".
+		print STDERR "Warning(${file}:$.): Function parameter ".
 		    "or member '$param' not " .
 		    "described in '$declaration_name'\n";
 	    }
 	    print STDERR "Warning(${file}:$.):".
-	                 " No description found for parameter '$param'\n";
+			 " No description found for parameter '$param'\n";
 	    ++$warnings;
-        }
-        }
+	}
+	}
 
 	push @parameterlist, $param;
 	$parametertypes{$param} = $type;
@@ -1664,10 +1664,10 @@ sub process_state3_function($$) {
 	# do nothing
     }
     elsif ($x =~ /([^\{]*)/) {
-        $prototype .= $1;
+	$prototype .= $1;
     }
     if (($x =~ /\{/) || ($x =~ /\#define/) || ($x =~ /;/)) {
-        $prototype =~ s@/\*.*?\*/@@gos;	# strip comments.
+	$prototype =~ s@/\*.*?\*/@@gos;	# strip comments.
 	$prototype =~ s@[\r\n]+@ @gos; # strip newlines/cr's.
 	$prototype =~ s@^\s+@@gos; # strip leading spaces
 	dump_function($prototype,$file);
@@ -1688,17 +1688,17 @@ sub process_state3_type($$) {
     }
 
     while (1) {
-        if ( $x =~ /([^{};]*)([{};])(.*)/ ) {
+	if ( $x =~ /([^{};]*)([{};])(.*)/ ) {
 	    $prototype .= $1 . $2;
 	    ($2 eq '{') && $brcount++;
 	    ($2 eq '}') && $brcount--;
 	    if (($2 eq ';') && ($brcount == 0)) {
-	        dump_declaration($prototype,$file);
+		dump_declaration($prototype,$file);
 		reset_state();
-	        last;
+		last;
 	    }
 	    $x = $3;
-        } else {
+	} else {
 	    $prototype .= $x;
 	    last;
 	}
@@ -1756,7 +1756,7 @@ sub process_file($) {
 		} else {
 			$section = $1;
 		}
-            }
+	    }
 	    elsif (/$doc_decl/o) {
 		$identifier = $1;
 		if (/\s*([\w\s]+?)\s*-/) {
@@ -1849,13 +1849,13 @@ sub process_file($) {
 	    }
 	} elsif ($state == 3) {	# scanning for function '{' (end of prototype)
 	    if ($decl_type eq 'function') {
-	        process_state3_function($_, $file);
+		process_state3_function($_, $file);
 	    } else {
-	        process_state3_type($_, $file);
+		process_state3_type($_, $file);
 	    }
 	} elsif ($state == 4) {
 		# Documentation block
-	        if (/$doc_block/) {
+		if (/$doc_block/) {
 			dump_section($section, $contents);
 			output_intro({'sectionlist' => \@sectionlist,
 				      'sections' => \%sections });
@@ -1873,7 +1873,7 @@ sub process_file($) {
 			} else {
 				$section = $1;
 			}
-                }
+		}
 		elsif (/$doc_end/)
 		{
 			dump_section($section, $contents);
@@ -1900,8 +1900,8 @@ sub process_file($) {
 			{
 				$contents .= $1 . "\n";
 			}
-        	}
-          }
+		}
+	}
     }
     if ($initial_section_counter == $section_counter) {
 	print STDERR "Warning(${file}): no structured comments found\n";
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
krealloc-fix-kerneldoc-comments.patch
git-acpi.patch
git-ieee1394.patch
romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
lib-hexdump.patch
lib-hexdump-fix.patch
lib-hexdump-update-on-feedback.patch
doc-what-a-patch-series-is.patch
kernel-doc-small-kernel-doc-optimization.patch
profile-likely-unlikely-macros.patch
