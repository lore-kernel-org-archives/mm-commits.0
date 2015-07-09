From: akpm@linux-foundation.org
Subject: +
 kerneldoc-convert-error-messages-to-gnu-error-message-format.patch added to -mm tree
Date: Thu, 09 Jul 2015 16:13:16 -0700
Message-ID: <559f000c.1znjoG3m9uHzG0kn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54013 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbbGIXNR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 19:13:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bart.vanassche@sandisk.com, johannes.berg@intel.com, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kerneldoc: Convert error messages to GNU error message format
has been added to the -mm tree.  Its filename is
     kerneldoc-convert-error-messages-to-gnu-error-message-format.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kerneldoc-convert-error-messages-to-gnu-error-message-format.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kerneldoc-convert-error-messages-to-gnu-error-message-format.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: kerneldoc: Convert error messages to GNU error message format

Editors like emacs and vi recognize a number of error message
formats. The format used by the kerneldoc tool is not recognized
by emacs. Change the kerneldoc error message format to the GNU
style such that the emacs prev-error and next-error commands can
be used to navigate through kerneldoc error messages. For more
information about the GNU error message format, see also
https://www.gnu.org/prep/standards/html_node/Errors.html.

This patch has been generated via the following sed command:

sed -i.orig 's/Error(\${file}:\$.):/\${file}:\$.: error:/g;s/Warning(\${file}:\$.):/\${file}:\$.: warning:/g;s/Warning(\${file}):/\${file}:1: warning:/g;s/Info(\${file}:\$.):/\${file}:\$.: info:/g' scripts/kernel-doc

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff -puN scripts/kernel-doc~kerneldoc-convert-error-messages-to-gnu-error-message-format scripts/kernel-doc
--- a/scripts/kernel-doc~kerneldoc-convert-error-messages-to-gnu-error-message-format
+++ a/scripts/kernel-doc
@@ -423,7 +423,7 @@ sub dump_section {
     } else {
 #	print STDERR "other section '$name' = '$contents'\n";
 	if (defined($sections{$name}) && ($sections{$name} ne "")) {
-		print STDERR "Error(${file}:$.): duplicate section name '$name'\n";
+		print STDERR "${file}:$.: error: duplicate section name '$name'\n";
 		++$errors;
 	}
 	$sections{$name} = $contents;
@@ -1772,7 +1772,7 @@ sub dump_struct($$) {
 			   });
     }
     else {
-	print STDERR "Error(${file}:$.): Cannot parse struct or union!\n";
+	print STDERR "${file}:$.: error: Cannot parse struct or union!\n";
 	++$errors;
     }
 }
@@ -1793,7 +1793,7 @@ sub dump_enum($$) {
 	    push @parameterlist, $arg;
 	    if (!$parameterdescs{$arg}) {
 		$parameterdescs{$arg} = $undescribed;
-		print STDERR "Warning(${file}:$.): Enum value '$arg' ".
+		print STDERR "${file}:$.: warning: Enum value '$arg' ".
 		    "not described in enum '$declaration_name'\n";
 	    }
 
@@ -1811,7 +1811,7 @@ sub dump_enum($$) {
 			   });
     }
     else {
-	print STDERR "Error(${file}:$.): Cannot parse enum!\n";
+	print STDERR "${file}:$.: error: Cannot parse enum!\n";
 	++$errors;
     }
 }
@@ -1839,7 +1839,7 @@ sub dump_typedef($$) {
 			   });
     }
     else {
-	print STDERR "Error(${file}:$.): Cannot parse typedef!\n";
+	print STDERR "${file}:$.: error: Cannot parse typedef!\n";
 	++$errors;
     }
 }
@@ -1971,11 +1971,11 @@ sub push_parameter($$$) {
 	    $parameterdescs{$param_name} = $undescribed;
 
 	    if (($type eq 'function') || ($type eq 'enum')) {
-		print STDERR "Warning(${file}:$.): Function parameter ".
+		print STDERR "${file}:$.: warning: Function parameter ".
 		    "or member '$param' not " .
 		    "described in '$declaration_name'\n";
 	    }
-	    print STDERR "Warning(${file}:$.):" .
+	    print STDERR "${file}:$.: warning:" .
 			 " No description found for parameter '$param'\n";
 	    ++$warnings;
 	}
@@ -2026,14 +2026,14 @@ sub check_sections($$$$$$) {
 		}
 		if ($err) {
 			if ($decl_type eq "function") {
-				print STDERR "Warning(${file}:$.): " .
+				print STDERR "${file}:$.: warning: " .
 					"Excess function parameter " .
 					"'$sects[$sx]' " .
 					"description in '$decl_name'\n";
 				++$warnings;
 			} else {
 				if ($nested !~ m/\Q$sects[$sx]\E/) {
-				    print STDERR "Warning(${file}:$.): " .
+				    print STDERR "${file}:$.: warning: " .
 					"Excess struct/union/enum/typedef member " .
 					"'$sects[$sx]' " .
 					"description in '$decl_name'\n";
@@ -2059,7 +2059,7 @@ sub check_return_section {
 
         if (!defined($sections{$section_return}) ||
             $sections{$section_return} eq "") {
-                print STDERR "Warning(${file}:$.): " .
+                print STDERR "${file}:$.: warning: " .
                         "No description found for return value of " .
                         "'$declaration_name'\n";
                 ++$warnings;
@@ -2138,7 +2138,7 @@ sub dump_function($$) {
 
 	create_parameterlist($args, ',', $file);
     } else {
-	print STDERR "Warning(${file}:$.): cannot understand function prototype: '$prototype'\n";
+	print STDERR "${file}:$.: warning: cannot understand function prototype: '$prototype'\n";
 	return;
     }
 
@@ -2202,7 +2202,7 @@ sub tracepoint_munge($) {
 		$tracepointargs = $1;
 	}
 	if (($tracepointname eq 0) || ($tracepointargs eq 0)) {
-		print STDERR "Warning(${file}:$.): Unrecognized tracepoint format: \n".
+		print STDERR "${file}:$.: warning: Unrecognized tracepoint format: \n".
 			     "$prototype\n";
 	} else {
 		$prototype = "static inline void trace_$tracepointname($tracepointargs)";
@@ -2401,7 +2401,7 @@ sub process_file($) {
 		}
 
 		if (($declaration_purpose eq "") && $verbose) {
-			print STDERR "Warning(${file}:$.): missing initial short description on line:\n";
+			print STDERR "${file}:$.: warning: missing initial short description on line:\n";
 			print STDERR $_;
 			++$warnings;
 		}
@@ -2419,10 +2419,10 @@ sub process_file($) {
 		}
 
 		if ($verbose) {
-		    print STDERR "Info(${file}:$.): Scanning doc for $identifier\n";
+		    print STDERR "${file}:$.: info: Scanning doc for $identifier\n";
 		}
 	    } else {
-		print STDERR "Warning(${file}:$.): Cannot understand $_ on line $.",
+		print STDERR "${file}:$.: warning: Cannot understand $_ on line $.",
 		" - I thought it was a doc line\n";
 		++$warnings;
 		$state = 0;
@@ -2434,7 +2434,7 @@ sub process_file($) {
 
 		if (($contents ne "") && ($contents ne "\n")) {
 		    if (!$in_doc_sect && $verbose) {
-			print STDERR "Warning(${file}:$.): contents before sections\n";
+			print STDERR "${file}:$.: warning: contents before sections\n";
 			++$warnings;
 		    }
 		    dump_section($file, $section, xml_escape($contents));
@@ -2461,7 +2461,7 @@ sub process_file($) {
 		}
 		# look for doc_com + <text> + doc_end:
 		if ($_ =~ m'\s*\*\s*[a-zA-Z_0-9:\.]+\*/') {
-		    print STDERR "Warning(${file}:$.): suspicious ending line: $_";
+		    print STDERR "${file}:$.: warning: suspicious ending line: $_";
 		    ++$warnings;
 		}
 
@@ -2491,7 +2491,7 @@ sub process_file($) {
 		}
 	    } else {
 		# i dont know - bad line?  ignore.
-		print STDERR "Warning(${file}:$.): bad line: $_";
+		print STDERR "${file}:$.: warning: bad line: $_";
 		++$warnings;
 	    }
 	} elsif ($state == 3) {	# scanning for function '{' (end of prototype)
@@ -2547,7 +2547,7 @@ sub process_file($) {
 	}
     }
     if ($initial_section_counter == $section_counter) {
-	print STDERR "Warning(${file}): no structured comments found\n";
+	print STDERR "${file}:1: warning: no structured comments found\n";
 	if (($function_only == 1) && ($show_not_found == 1)) {
 	    print STDERR "    Was looking for '$_'.\n" for keys %function_table;
 	}
_

Patches currently in -mm which might be from bart.vanassche@sandisk.com are

kerneldoc-convert-error-messages-to-gnu-error-message-format.patch
linux-next.patch

