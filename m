From: akpm@linux-foundation.org
Subject: + gconfig-disable-typeahead-find-search-in-treeviews.patch added to -mm tree
Date: Fri, 11 Sep 2009 14:39:24 -0700
Message-ID: <200909112139.n8BLdOZp029624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756617AbZIKVkM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Sep 2009 17:40:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: flameeyes@gmail.com, sam@ravnborg.org, zippel@linux-m68k.org


The patch titled
     gconfig: disable "typeahead find" search in treeviews
has been added to the -mm tree.  Its filename is
     gconfig-disable-typeahead-find-search-in-treeviews.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: gconfig: disable "typeahead find" search in treeviews
=46rom: Diego Elio 'Flameeyes' Petten=F2 <flameeyes@gmail.com>

When typeahead find is enabled, using 'y', 'n' and 'm' to change the st=
atus
of the configuration items will also start up the search system, making=
 you
jump around the configuration.

Disabling the enable_search property does not mean that search is not
possible, it only disables the typeahead; to execute a search in the
treeview, you can just call it up explicitly (i.e.: on most systems tha=
t
will be Ctrl-f).

Signed-off-by: Diego Elio 'Flameeyes' Petten=F2  <flameeyes@gmail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/gconf.glade |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/kconfig/gconf.glade~gconfig-disable-typeahead-find-se=
arch-in-treeviews scripts/kconfig/gconf.glade
--- a/scripts/kconfig/gconf.glade~gconfig-disable-typeahead-find-search=
-in-treeviews
+++ a/scripts/kconfig/gconf.glade
@@ -547,7 +547,7 @@
 		  <property name=3D"headers_visible">True</property>
 		  <property name=3D"rules_hint">False</property>
 		  <property name=3D"reorderable">False</property>
-		  <property name=3D"enable_search">True</property>
+		  <property name=3D"enable_search">False</property>
 		  <signal name=3D"cursor_changed" handler=3D"on_treeview2_cursor_cha=
nged" last_modification_time=3D"Sun, 12 Jan 2003 15:58:22 GMT"/>
 		  <signal name=3D"button_press_event" handler=3D"on_treeview1_button=
_press_event" last_modification_time=3D"Sun, 12 Jan 2003 16:03:52 GMT"/=
>
 		  <signal name=3D"key_press_event" handler=3D"on_treeview2_key_press=
_event" last_modification_time=3D"Sun, 12 Jan 2003 16:11:44 GMT"/>
@@ -582,7 +582,7 @@
 		      <property name=3D"headers_visible">True</property>
 		      <property name=3D"rules_hint">False</property>
 		      <property name=3D"reorderable">False</property>
-		      <property name=3D"enable_search">True</property>
+		      <property name=3D"enable_search">False</property>
 		      <signal name=3D"cursor_changed" handler=3D"on_treeview2_cursor=
_changed" last_modification_time=3D"Sun, 12 Jan 2003 15:57:55 GMT"/>
 		      <signal name=3D"button_press_event" handler=3D"on_treeview2_bu=
tton_press_event" last_modification_time=3D"Sun, 12 Jan 2003 15:57:58 G=
MT"/>
 		      <signal name=3D"key_press_event" handler=3D"on_treeview2_key_p=
ress_event" last_modification_time=3D"Sun, 12 Jan 2003 15:58:01 GMT"/>
_

Patches currently in -mm which might be from flameeyes@gmail.com are

gconfig-disable-typeahead-find-search-in-treeviews.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
